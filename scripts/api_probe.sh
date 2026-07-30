#!/usr/bin/env bash
#
# Endpoint probe for HealthPilot backend — auth, profile, contacts, health,
# nutrition, medications, and subscriptions.
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

############################  CONTACTS  ############################
step "CONTACTS: GET /profile/emergency-contacts/"
call GET "/profile/emergency-contacts/"

step "CONTACTS: POST /profile/emergency-contacts/ (create temp)"
call POST "/profile/emergency-contacts/" \
  '{"first_name":"__probe","last_name":"Contact","relationship":"OTHER","phone":"+15550001111","email":"probe.contact@example.com"}'
EC_ID="$(pick_id)"
info "created emergency contact id = ${EC_ID:-<none>}"

if [[ -n "$EC_ID" ]]; then
  step "CONTACTS: GET /profile/emergency-contacts/$EC_ID/"
  call GET "/profile/emergency-contacts/$EC_ID/"

  step "CONTACTS: PATCH /profile/emergency-contacts/$EC_ID/ (no-op phone echo)"
  call PATCH "/profile/emergency-contacts/$EC_ID/" \
    '{"first_name":"__probe","last_name":"Contact","relationship":"OTHER","phone":"+15550001111","email":"probe.contact@example.com"}'

  step "CONTACTS: DELETE /profile/emergency-contacts/$EC_ID/ (cleanup)"
  call DELETE "/profile/emergency-contacts/$EC_ID/"
fi

step "CONTACTS: GET /profile/doctors/"
call GET "/profile/doctors/"

step "CONTACTS: POST /profile/doctors/ (create temp)"
call POST "/profile/doctors/" \
  '{"first_name":"Dr","last_name":"Probe","profession":"General Practice","phone":"+15550002222","email":"probe.doctor@example.com","report_frequency":2}'
DOC_ID="$(pick_id)"
info "created doctor id = ${DOC_ID:-<none>}"

if [[ -n "$DOC_ID" ]]; then
  step "CONTACTS: GET /profile/doctors/$DOC_ID/"
  call GET "/profile/doctors/$DOC_ID/"

  step "CONTACTS: PATCH /profile/doctors/$DOC_ID/ (no-op echo)"
  call PATCH "/profile/doctors/$DOC_ID/" \
    '{"first_name":"Dr","last_name":"Probe","profession":"General Practice","phone":"+15550002222","email":"probe.doctor@example.com","report_frequency":2}'

  step "CONTACTS: DELETE /profile/doctors/$DOC_ID/ (cleanup)"
  call DELETE "/profile/doctors/$DOC_ID/"
fi

############################  HEALTH  ############################
step "HEALTH: GET /health/symptoms/"
call GET "/health/symptoms/"

step "HEALTH: POST /health/symptoms/ (create temp 1)"
call POST "/health/symptoms/" '{"symptom_name":"__probe_bulk_1","severity":2}'

step "HEALTH: POST /health/symptoms/ (create temp 2)"
call POST "/health/symptoms/" '{"symptom_name":"__probe_bulk_2","severity":4}'

step "HEALTH: DELETE /health/symptoms/ (bulk delete all)"
call DELETE "/health/symptoms/"

step "HEALTH: GET /health/symptoms/ (verify empty after bulk delete)"
call GET "/health/symptoms/"

step "HEALTH: POST /health/symptoms/ (create temp for individual test)"
call POST "/health/symptoms/" '{"symptom_name":"__probe_symptom","severity":3}'
SYMPTOM_ID="$(echo "$LAST_BODY" | jq -r '.data.id // .id // empty')"
info "created symptom id = ${SYMPTOM_ID:-<none>}"

if [[ -n "$SYMPTOM_ID" ]]; then
  step "HEALTH: GET /health/symptoms/$SYMPTOM_ID/"
  call GET "/health/symptoms/$SYMPTOM_ID/"

  step "HEALTH: DELETE /health/symptoms/$SYMPTOM_ID/ (individual cleanup)"
  call DELETE "/health/symptoms/$SYMPTOM_ID/"
fi

step "HEALTH: GET /health/conditions/ (backend confirmed no /health/conditions/ endpoint — expect 404)"
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

############################  COMMUNITY & CHAT  ############################
step "COMMUNITY: GET /community/groups/"
call GET "/community/groups/"

step "COMMUNITY: POST /community/groups/ (create temp)"
call POST "/community/groups/" \
  '{"name":"__probe_community","slug":"probe-community","description":"Temporary probe community","is_public":true}'
COMM_ID="$(echo "$LAST_BODY" | jq -r '.data.id // .id // empty')"
CHAT_GROUP_ID="$(echo "$LAST_BODY" | jq -r '.data.chat_group_id // empty')"
info "created community id = ${COMM_ID:-<none>}, chat_group_id = ${CHAT_GROUP_ID:-<none>}"

if [[ -n "$COMM_ID" ]]; then
  step "COMMUNITY: GET /community/groups/$COMM_ID/"
  call GET "/community/groups/$COMM_ID/"

  step "COMMUNITY: POST /community/groups/$COMM_ID/join/"
  call POST "/community/groups/$COMM_ID/join/"

  if [[ -n "$CHAT_GROUP_ID" ]]; then
    step "CHAT: GET /chat/groups/$CHAT_GROUP_ID/messages/"
    call GET "/chat/groups/$CHAT_GROUP_ID/messages/"

    step "CHAT: POST /chat/groups/$CHAT_GROUP_ID/messages/ (send temp message)"
    call POST "/chat/groups/$CHAT_GROUP_ID/messages/" \
      '{"content":"__probe_message from api_probe.sh"}'
  fi

  step "COMMUNITY: POST /community/groups/$COMM_ID/leave/"
  call POST "/community/groups/$COMM_ID/leave/"

  step "COMMUNITY: DELETE /community/groups/$COMM_ID/ (cleanup)"
  call DELETE "/community/groups/$COMM_ID/"
fi

step "Done. (logout intentionally skipped to keep refresh token valid)"
