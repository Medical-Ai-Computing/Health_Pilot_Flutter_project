#!/usr/bin/env bash
#
# Endpoint probe for HealthPilot backend — auth, profile, health, nutrition,
# medications, and subscriptions.
# Logs in, then GETs each read endpoint and exercises safe create→delete
# writes, printing every response so payload shapes can be compared against
# the app's parsing code.
#
# Requires: curl, jq
# Usage: ./scripts/api_probe.sh   (optional EMAIL=… PASSWORD=… BASE_URL=…)
#
# Subscription write probes (subscribe / cancel / payment confirm) are skipped
# by default so the probe does not mutate live membership. Set PROBE_SUBSCRIPTION_WRITES=1
# to exercise POST /subscriptions/payment/ (creates a pending payment only).

set -uo pipefail

BASE_URL="${BASE_URL:-https://pulsminds-healthpilot.chickenkiller.com}"
BASE_URL="${BASE_URL%/}"
API="$BASE_URL/api/v1"
EMAIL="${EMAIL:-dechassa0@gmail.com}"
PASSWORD="${PASSWORD:-StrongPass123!}"
PROBE_SUBSCRIPTION_WRITES="${PROBE_SUBSCRIPTION_WRITES:-0}"

command -v jq >/dev/null 2>&1 || { echo "ERROR: jq required"; exit 1; }

step()  { printf '\n\033[1;36m=== %s ===\033[0m\n' "$*"; }
info()  { printf '\033[2m%s\033[0m\n' "$*"; }
ACCESS=""; REFRESH=""; LAST_BODY=""

# Extract an id from envelope, flat, or paginated list responses.
pick_id() {
  echo "$LAST_BODY" | jq -r '.data.id // .id // (.results[0].id // empty) // empty'
}

call() {
  local method="$1" path="$2" body="${3:-}"
  local url="$API$path" tmp http
  info "→ $method $url${body:+  $body}"
  tmp="$(mktemp)"
  if [[ -n "$body" ]]; then
    http="$(curl -sS -o "$tmp" -w '%{http_code}' -X "$method" "$url" \
      -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json' -d "$body")"
  else
    http="$(curl -sS -o "$tmp" -w '%{http_code}' -X "$method" "$url" \
      -H "Authorization: Bearer $ACCESS" -H 'Content-Type: application/json')"
  fi
  printf '  HTTP %s\n' "$http"
  if jq -e . "$tmp" >/dev/null 2>&1; then jq . "$tmp"; else cat "$tmp"; echo; fi
  LAST_BODY="$(cat "$tmp")"; rm -f "$tmp"
}

# --- Login -------------------------------------------------------------------
step "LOGIN"
LOGIN_RESP="$(curl -sS -X POST "$API/auth/login/" -H 'Content-Type: application/json' \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")"
ACCESS="$(echo "$LOGIN_RESP" | jq -r '.data.access // .access // empty')"
REFRESH="$(echo "$LOGIN_RESP" | jq -r '.data.refresh // .refresh // empty')"
[[ -z "$ACCESS" ]] && { echo "$LOGIN_RESP"; echo "LOGIN FAILED"; exit 1; }
info "got token (${#ACCESS} chars), user id $(echo "$LOGIN_RESP" | jq -r '.data.user.id')"

############################  AUTH  ############################
step "AUTH: GET /auth/me/"
call GET "/auth/me/"

step "AUTH: PATCH /auth/me/ (no-op echo of current allergies)"
CUR_ALLERGIES="$(echo "$LAST_BODY" | jq -r '.data.allergies // ""')"
call PATCH "/auth/me/" "{\"allergies\": $(jq -Rn --arg a "$CUR_ALLERGIES" '$a')}"

step "AUTH: POST /auth/token/refresh/"
call POST "/auth/token/refresh/" "{\"refresh\": \"$REFRESH\"}"

step "AUTH: POST /auth/register/ (existing email → expect validation error shape)"
call POST "/auth/register/" "{\"email\":\"$EMAIL\",\"first_name\":\"x\",\"last_name\":\"y\",\"password\":\"$PASSWORD\",\"password2\":\"$PASSWORD\"}"

step "AUTH: POST /auth/resend-activation/ (already active → observe shape)"
call POST "/auth/resend-activation/" "{\"email\":\"$EMAIL\"}"

############################  PROFILE  ############################
step "PROFILE: GET /profile/me/"
call GET "/profile/me/"

step "PROFILE: PATCH /profile/me/ (echo current is_visible_in_community)"
VIS="$(echo "$LAST_BODY" | jq -r '.data.is_visible_in_community // true')"
call PATCH "/profile/me/" "{\"is_visible_in_community\": $VIS}"

############################  HEALTH  ############################
step "HEALTH: GET /health/symptoms/"
call GET "/health/symptoms/"

step "HEALTH: POST /health/symptoms/ (create temp)"
call POST "/health/symptoms/" '{"symptom_name":"__probe_symptom","severity":3}'
SYMPTOM_ID="$(echo "$LAST_BODY" | jq -r '.data.id // .id // empty')"
info "created symptom id = ${SYMPTOM_ID:-<none>}"

if [[ -n "$SYMPTOM_ID" ]]; then
  step "HEALTH: DELETE /health/symptoms/$SYMPTOM_ID/ (cleanup)"
  call DELETE "/health/symptoms/$SYMPTOM_ID/"
fi

step "HEALTH: GET /health/conditions/ (app says this doesn't exist — verify)"
call GET "/health/conditions/"

############################  NUTRITION  ############################
step "NUTRITION: GET /nutrition/settings/"
call GET "/nutrition/settings/"

step "NUTRITION: GET /nutrition/history/"
call GET "/nutrition/history/"

############################  MEDICATIONS  ############################
step "MEDICATIONS: GET /medications/"
call GET "/medications/"

step "MEDICATIONS: POST /medications/ (create temp)"
call POST "/medications/" \
  '{"medication_name":"__probe_med","dosage_amount":100,"dosage_unit":"mg","doses_per_day":1}'
MED_ID="$(pick_id)"
info "created medication id = ${MED_ID:-<none>}"

if [[ -n "$MED_ID" ]]; then
  step "MEDICATIONS: GET /medications/$MED_ID/"
  call GET "/medications/$MED_ID/"

  step "MEDICATIONS: PATCH /medications/$MED_ID/ (no-op dosage echo)"
  call PATCH "/medications/$MED_ID/" \
    '{"medication_name":"__probe_med","dosage_amount":100,"dosage_unit":"mg","doses_per_day":1}'

  step "MEDICATIONS: POST /medications/$MED_ID/reminders/ (create temp)"
  call POST "/medications/$MED_ID/reminders/" \
    '{"reminder_time":"08:00","days_of_week":[0,1,2,3,4,5,6]}'
  REMINDER_ID="$(pick_id)"
  info "created reminder id = ${REMINDER_ID:-<none>}"

  step "MEDICATIONS: GET /medications/$MED_ID/reminders/"
  call GET "/medications/$MED_ID/reminders/"

  if [[ -n "$REMINDER_ID" ]]; then
    step "MEDICATIONS: PATCH /medications/$MED_ID/reminders/$REMINDER_ID/ (no-op)"
    call PATCH "/medications/$MED_ID/reminders/$REMINDER_ID/" \
      '{"reminder_time":"08:00","days_of_week":[0,1,2,3,4,5,6]}'

    step "MEDICATIONS: DELETE /medications/$MED_ID/reminders/$REMINDER_ID/ (cleanup)"
    call DELETE "/medications/$MED_ID/reminders/$REMINDER_ID/"
  fi

  step "MEDICATIONS: POST /medications/$MED_ID/doses/ (log taken dose)"
  call POST "/medications/$MED_ID/doses/" \
    '{"status":"taken","scheduled_at":"2026-06-21T08:00:00Z","taken_at":"2026-06-21T08:05:00Z"}'

  step "MEDICATIONS: GET /medications/$MED_ID/doses/"
  call GET "/medications/$MED_ID/doses/"

  step "MEDICATIONS: DELETE /medications/$MED_ID/ (cleanup)"
  call DELETE "/medications/$MED_ID/"
fi

############################  SUBSCRIPTIONS  ############################
step "SUBSCRIPTIONS: GET /subscriptions/plans/"
call GET "/subscriptions/plans/"

step "SUBSCRIPTIONS: GET /subscriptions/status/"
call GET "/subscriptions/status/"

step "SUBSCRIPTIONS: GET /subscriptions/payment/history/"
call GET "/subscriptions/payment/history/"

if [[ "$PROBE_SUBSCRIPTION_WRITES" == "1" ]]; then
  step "SUBSCRIPTIONS: POST /subscriptions/payment/ (creates pending payment — observe shape)"
  call POST "/subscriptions/payment/" \
    '{"amount":9.99,"payment_method":"credit_card"}'
  PAYMENT_ID="$(pick_id)"
  info "created payment id = ${PAYMENT_ID:-<none>} (confirm/subscribe/cancel skipped)"
else
  info "Skipping subscription write probes (set PROBE_SUBSCRIPTION_WRITES=1 to POST /subscriptions/payment/)."
  info "subscribe / cancel / payment confirm are always skipped to avoid mutating live membership."
fi

step "Done. (logout intentionally skipped to keep refresh token valid)"
