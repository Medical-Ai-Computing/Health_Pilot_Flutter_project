# Gap Fix Plan

Derived from comparing the live Swagger spec at
`https://pulsminds-healthpilot.chickenkiller.com/swagger.json`
(**81 paths / 119 path+method operations**) against the Flutter app codebase
(remote repos, providers, screens, navigation).

Branches are ordered by priority. Each branch must keep `flutter analyze` clean.

## Progress

| Branch | Status | Notes |
|---|---|---|
| 1 — Data-layer correctness | ✅ Done | `743ed87` |
| 2 — Provider surface gaps | ✅ Done | `6a6de30` |
| 3 — Live-wire missing UI | ✅ Done | (commits listed below) |
| 4 — WebSocket real-time chat | ❌ Cancelled | Decision: not using WebSockets in this project |
| 5 — Nutrition endpoint remapping | ✅ Done | Covered in Branch 1 (`743ed87`) |
| 6 — Guest assessment flow | ✅ Done | |
| 7 — Health repo minor endpoints | ✅ Done | |
| 8 — Community↔chat bridge | ⏳ Deferred | Blocked on backend shipping `chat_group_id` |
| 9 — UI dead controls sweep | ✅ Done | |
| 10 — Field-level parse/render re-audit | ✅ Done | Added after re-probing live payloads — see below |

---

## Branch 1 — Data-layer correctness fixes (P0) ✅

**Goal:** Fix remote-repo methods that call the wrong URL, wrong HTTP verb, or a
non-existent endpoint. These are live bugs that will crash or silently fail when
the corresponding feature flag is `true`.

| File | Fix | Status |
|---|---|---|
| `remote_subscription_repository.dart` `cancelSubscription()` | Changed `DELETE` → **`POST`** to match Swagger `POST /subscriptions/cancel/` | ✅ `743ed87` |
| `remote_nutrition_repository.dart` `fetchHistory()` | Standardised on `GET /meals/` | ✅ `743ed87` |
| `remote_nutrition_repository.dart` `addMeal()` | Standardised on `POST /meals/` | ✅ `743ed87` |
| `remote_nutrition_repository.dart` `fetchGoals()` / `saveGoals()` | Standardised on `/goals/` | ✅ `743ed87` |
| `remote_health_repository.dart` `clearSymptoms()` | Made a no-op (backend has no bulk `DELETE /health/symptoms/`) | ✅ `743ed87` |
| `remote_health_repository.dart` `fetchConditions()` | Returns `[]` — conditions endpoint doesn't exist on backend | ⏳ Won't fix (no backend endpoint) |

> **Correction (re-audit 2026-07-02):** the original rationale for the nutrition
> rewires ("`/history/` and `/settings/` don't exist") was wrong. Live probing
> shows `/nutrition/history/` == `/nutrition/meals/` and `/nutrition/settings/`
> == `/nutrition/goals/` return **identical payloads** — they are backend
> aliases and both always worked. The rewires were harmless standardisation, not
> bug fixes. `fetchConditions()` returning `[]` and `clearSymptoms()` as a no-op
> are still correct (those endpoints genuinely don't exist).

**Acceptance:** `FF_* = true` for affected features does not throw 404/405.

---

## Branch 2 — Provider surface gaps (P1) ✅

**Goal:** Expose already-implemented remote-repo methods through their
providers so screens can call them. **Commit `6a6de30`.**

| Provider | Method | Status |
|---|---|---|
| `ArticleProvider` | `fetchRecommended()`, `fetchBookmarks()`, `fetchArticle(id)`, `toggleBookmark(id)`, `fetchComments(id)`, `addComment(id, text)` | ✅ All added |
| `AssessmentProvider` | `submitGuestAssessment(summary)` | ✅ Added |
| `HealthProvider` | `fetchSummaries()` (+ `IHealthRepository`, `RemoteHealthRepository`, `MockHealthRepository`) | ✅ All layers added |

---

## Branch 3 — Live-wire missing UI (P2 high) ✅

**Goal:** Surface features whose data layer exists but have no screen or have
dead UI controls.

### 3a — Notification centre screen ✅
- Created `lib/features/notifications/notifications_screen.dart`
  - List from `NotificationProvider.items`
  - Tap → `markRead(id)`
  - "Mark all read" action in app bar
- Wired home bell icon `onTap` to push `NotificationsScreen`

### 3b — Article comment screen (unstick) ✅
- Removed fake `CommentModel`/`Reply` classes and `sampleThreadedArticleComments()`
- Changed screen to load comments from `ArticleProvider.fetchComments()` on init
- Wired "Post" button → `context.read<ArticleProvider>().addComment(id, text)`
- Updated `article_detail_screen.dart` caller to pass article only (no more `comments: []`)

### 3c — Assessment delete affordance ✅
- Wrapped assessment history rows in `Dismissible` (end-to-start swipe)
- Confirmation dialog → `AssessmentProvider.delete(id)` on confirm

### 3d — Symptom row tap ✅
- Changed `symptom_tracking_screen.dart` row `onTap: () {}` to show delete confirmation dialog
- On confirm → `HealthProvider.deleteSymptom(id)`

### 3e — Payment flow in subscription screen
- **Not implemented.** `SubscriptionProvider` methods exist but subscription/payment UI has
  hardcoded amounts and no gateway flow. Deferred pending product requirements.

### 3f — Reset password deep link ✅
- Added `ActivationLink.parseResetToken()` to extract `?reset_token=<uuid>` or path-contains-"reset"
- Added `initialResetToken` / `onResetPassword` to `ActivationLinkHandler`
- Added `_onResetPasswordDeepLink` in `main.dart` → navigates to `ResetPasswordScreen(token:)`
- Cold-start handling in `WelcomeScreen._goToNextScreen()`

---

## Branch 4 — WebSocket real-time chat (P2 medium) ❌ Cancelled

Decision: the project will not use WebSockets. Chat polling every 15s remains in place.

---

## Branch 5 — Nutrition endpoint remapping (P2 low) ✅

**Covered by Branch 1** (`commit 743ed87`). All three endpoint rewires done:
1. ✅ `fetchHistory()` → `GET /nutrition/meals/`
2. ✅ `fetchGoals()` → `GET /nutrition/goals/`
3. ✅ `saveGoals()` → `PATCH /nutrition/goals/`
4. ✅ `fetchSummary()` → stays at `GET /nutrition/summary/` (confirmed correct)
5. ⏳ Keep `/nutrition/settings/` for app-level preferences — wire when UI needs it

---

## Branch 6 — Guest assessment flow (P3) ✅

**Changes:**
1. ✅ `submitGuestAssessment` already added to `AssessmentProvider` in Branch 2
2. ✅ `summary_screen.dart`: `_onPrimaryPressed` checks `auth.isGuest` — guests call
   `provider.submitGuestAssessment(_summary)` instead of `provider.submit(_summary)`
3. ✅ `home_page_screen.dart`: Added a `Card` CTA "Try our symptom checker" — visible
   only when `auth.isGuest`, navigates to `HealthAssessmentFlowScreen`

**Acceptance:** Guest users can run an assessment. Backend returns results but does not
persist them (no history entry for guests).

---

## Branch 7 — Health repo minor endpoints (P3) ✅

**Goal:** Implement single-item fetch endpoints listed in Swagger but missing from the repo.

Added to all three layers (`IHealthRepository`, `RemoteHealthRepository`, `MockHealthRepository`):

| Method | Endpoint |
|---|---|
| `fetchVital(int id)` | `GET /health/vitals/{id}/` |
| `fetchGoal(int id)` | `GET /health/goals/{id}/` |

Remaining gaps intentionally skipped:
- `PUT /health/goals/{id}/` — PATCH suffices for partial updates
- `GET /health/summaries/` (list) — already implemented as `fetchSummaries()`

---

## Branch 8 — Chat community→group bridge (P3 deferred)

**Current state:** `community_groups_screen.dart` `_openChat` can dead-end with
"Group Not Found" because `chatGroupId` is always `null` — the backend hasn't
shipped the link field yet. The `CommunityGroup.fromJson` parser already reads
`chat_group_id` / `group_chat_id` and stores it as `chatGroupId`. Nothing to
do on the Flutter side until the backend ships the field.

**Hold:** Await backend delivery of the `chat_group_id` field on the community
group response. Once available, wire `_openChat` to join the linked group chat
and navigate to `GroupChatScreen`.

---

## Branch 9 — UI dead controls sweep (P4) ✅

Single pass to wire or remove all remaining no-op interactive elements:

| Screen | Control | Fix |
|---|---|---|
| `chat_screen.dart` | `more: () {}` | SnackBar "User details coming soon" |
| `chat_screen.dart` | `attach: debugPrint` | SnackBar "File sharing coming soon" |
| `group_chat_screen.dart` | `more: () {}` | SnackBar "Group details coming soon" |
| `group_chat_screen.dart` | `attach: () {}` | SnackBar "File sharing coming soon" |
| `assessment_detail_screen.dart` | "Show nearest hospitals" | SnackBar "Hospital locator coming soon" |
| `health_profile_screen.dart` | Warning icon `onTap` | SnackBar "Emergency alert coming soon" |
| `health_profile_screen.dart` | Symptom row `onTap` | Delete confirmation dialog → `HealthProvider.deleteSymptom(id)` |
| `health_profile_screen.dart` | Health Profiles Add button | SnackBar "Add profile coming soon" |
| `health_profile_screen.dart` | Profile row `onTap` | SnackBar "Profile details coming soon" |
| `health_profile_screen.dart` | "Edit" button | SnackBar "Edit profile coming soon" |
| `health_profile_screen.dart` | Arrow `IconButton` | Replaced with plain `Icon`; whole row wrapped in `InkWell(onTap:)` |
| `health_profile_screen.dart` | "Subscribe" button | SnackBar "Subscription coming soon" |
| `blog_reccomendation._card.dart` | "Consult our doctors" card | SnackBar "Doctor consultation coming soon" |
| `user_detail_screen.dart` | `more: () {}` | SnackBar "More options coming soon" |
| `user_detail_screen.dart` | Notification toggle `debugPrint` | SnackBar showing on/off state |
| `home_page_screen.dart` | "Tell us your symptoms" text | `GestureDetector` → navigates to `SymptomTrackingScreen` |

---

## Branch 10 — Field-level parse/render re-audit (P1) ✅

**Context:** Branches 1–9 fixed endpoint URLs, verbs and UI wiring, but did **not**
audit whether model `fromJson` field names/types and widget rendering match the
**actual** response bodies. A second pass re-probed every live endpoint group
(authenticated) and compared real payloads against the app's parsing/rendering.
Health, nutrition, chat, community, notifications and profile all checked out.
Articles and subscriptions did not — five confirmed bugs, all latent until the
matching `FF_*` flag is `true`:

| # | Severity | Bug | Fix |
|---|---|---|---|
| 1 | High | Live `image_url` is a **network** URL but 3 article screens drew it with `Image.asset`/`AssetImage` (crash/broken image) | Added `ArticleFeedItem.imageProvider` (Network vs Asset by `http` prefix); swapped `article_screen.dart`, `article_detail_screen.dart`, `article_comment_screen.dart` |
| 2 | High | `SubscriptionPlan`/`SubscriptionStatus.fromJson` read `price_monthly`/`plan_id`/`is_active`/`expires_at`; live sends `price`/`plan`/`is_premium`/`end_date` → non-nullable cast `TypeError` on every response | Renamed keys (null-safe, legacy fallbacks); `isPremium` for plans derived from `id != 'free'` |
| 3 | Minor | Article like/comment counts read `likes`/`comments_count`; live sends `like_count`/`comment_count` → always 0 | Read live keys with legacy fallback |
| 4 | UX | Detail screen never fetched `GET /articles/{id}/`, so it showed the feed `summary`, never the full `body` | Made `ArticleDetail` stateful; fetches full article via `fetchArticle(id)` on open |
| 5 | Minor | `ChatGroup` ignored the list endpoint's `last_message`, so group previews were blank until history loaded | Parse `last_message.content` into `lastMessagePreview`; used as thread subtitle fallback |

**Acceptance:** `flutter analyze` clean (no new issues); article images render,
subscription screens don't throw, article detail shows full body.

---

## Appendix — Full endpoint coverage matrix

| Endpoint group | Total | Implemented | Missing | Branch |
|---|---|---|---|---|
| Auth | 14 | 14 | 0 (POST activate is optional; GET variant works) | — |
| Profile | 8 | 8 | 0 | — |
| Health | 20 | 17 | 3 (PUT goal, individual fetch stubs removed) | 7 |
| Medications | 12 | 12 | 0 | — |
| Articles | 10 | 10 | 0 (image/body/count parsing fixed) | 10 |
| Assessment | 4 | 4 | 0 | 6 |
| Chat | 20 | 18 | 2 skipped intentionally (alias routes) | — |
| Community | 9 | 9 | 0 | — |
| Notifications | 4 | 4 | 0 | 3a |
| Subscriptions | 8 | 8 | 0 (plan/status parsing fixed) | 10 |
| Nutrition | 10 | 10 | 0 | — |
| Ads | 2 | 2 | 0 | — |
| **Total** | **121** | **117** | **4** | |

> **Note (re-audit 2026-07-02):** these per-group tallies are the original
> author's hand-count and don't sum to the authoritative spec figure
> (**81 paths / 119 path+method operations**, re-probed 2026-07-02). Treat the
> matrix as a coverage sketch, not an exact endpoint census.
