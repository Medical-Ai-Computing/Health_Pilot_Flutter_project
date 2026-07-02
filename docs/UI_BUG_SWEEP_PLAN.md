# UI/UX Bug Sweep — Fix Plan

Independent bug/UX sweep of the HealthPilot Flutter app (not derived from the
Swagger gap analysis). Findings were traced directly in code on **2026-07-02**.
Each item is a checkbox — tick it as the fix lands and `flutter analyze` stays clean.

Severity legend: **P0** = broken/crashy or shows wrong data · **P1** = clear UX
defect · **P2** = polish/minor. `(PLAUSIBLE)` = strong suspicion, confirm on-device.

## Progress

| # | Priority | Area | Item | Status |
|---|---|---|---|---|
| 1 | P0 | Chat | Conversation blanks to spinner every 15s poll | ✅ |
| 2 | P1 | Assessment | "Search symptom" field is dead | ✅ |
| 3 | P1 | Home | Fabricated BMI / sleep metrics | ✅ |
| 4 | P1 | Home | Tabs don't preserve state (no IndexedStack) | ✅ |
| 5 | P1 | Nutrition | Add-meal drops selected food's macros | ✅ |
| 6 | P1 | Community | Create-group dialog leaks 3 controllers | ✅ |
| 7 | P2 | Assessment | Dead refresh button | ✅ |
| 8 | P2 | Assessment | Placeholder help sheets echo the label | ✅ |
| 9 | P2 | Assessment | "their blood type" copy when subject is Myself | ✅ |
| 10 | P2 | Chat | "more" says coming-soon but avatar opens details | ✅ |
| 11 | P2 | Chatbot | Uncaught StateError if cleared mid-send | ✅ |
| 12 | P2 | Chatbot | AI history is local-only, server history never loaded | ✅ |

---

## P0 — Broken / wrong data

### 1. Private & group chat blank out to a spinner every 15 seconds
- [x] **Fixed** — added a per-screen `_initialLoadDone` flag; the full-screen spinner now shows only
  while `isLoadingThread(id) && !_initialLoadDone`, so the 15s background poll updates silently.
  Applied to `chat_screen.dart` and `group_chat_screen.dart`; `flutter analyze` clean.
- **Where:** `lib/features/chat/chat_screen.dart:108`, `lib/features/chat/group_chat_screen.dart:100`
- **Cause:** the 15s poll calls `fetchPrivateMessages` / `fetchGroupMessages`, which both do
  `_loadingThreads.add(id); notifyListeners()` (`chat_provider.dart:329`, `:466`). The screens
  render a full-screen `CircularProgressIndicator` whenever `isLoadingThread(id)` is true.
- **Failure scenario:** while reading a thread, every poll cycle replaces the whole message list
  with a spinner, then repaints — flicker + scroll jump every 15s.

---

## P1 — Clear UX defects

### 2. Assessment "Search symptom" field is dead
- [x] **Fixed** — `_SymptomsPage` is now stateful: it listens to the search controller, filters a
  12-item symptom catalog case-insensitively, and shows an "Add “…”" row (plus keyboard-submit) so
  free-text symptoms can be added to `_selectedSymptoms`. Dropped the `'Cough'` search prefill (kept
  it as a preselected chip). `flutter analyze` clean.
- **Where:** `lib/features/health_assessment/health_assessment_flow_screen.dart` (`_SymptomsPage`,
  shared search controller)
- **Cause:** the symptom `TextField` had a controller but no `onChanged`/`onSubmitted`; the
  suggestion list was 3 hardcoded items. Preselected `'Cough'` had no matching suggestion row.
- **Failure scenario:** user couldn't search or add a typed symptom — entry was hardcoded to 3 toggles.

### 3. Home shows fabricated health metrics
- [x] **Fixed** — BMI now falls back to `—` (placeholder) when `profile.bmi` is null instead of the
  hardcoded `21.6`; a real value still shows when height+weight exist. The always-`6.5 hours` sleep
  card is now commented out (no data source), matching the already-hidden BPM card. `flutter analyze` clean.
- **Where:** `lib/features/home/home_page_screen.dart` (Overview row)
- **Failure scenario:** when profile BMI was null the card showed a hardcoded `21.6`; the sleep card
  was always `6.5 hours`. Users saw invented numbers presented as their own data.

### 4. Home tabs don't preserve state
- [x] **Fixed** — `body` now wraps the pages in `IndexedStack(index: _currentIndex,
  sizing: StackFit.expand, children: pages)`, so all five subtrees stay mounted (offstage) and their
  scroll/in-progress state survives tab switches. Verified no tab does navigation/timers in
  `initState` (only provider loads via post-frame, which now also warms the Profile tab so the Home
  BMI card populates at launch). `flutter analyze` clean.
- **Where:** `lib/features/home/home_page_screen.dart` (Scaffold `body`)
- **Failure scenario:** the 5 tab bodies were swapped by index (`pages[_currentIndex]`), so
  Home→Health→Home reset scroll/in-progress input; every subtree was reconstructed on each switch.

### 5. Add-meal drops a selected food's macros
- [x] **Fixed (confirmed)** — removed the `controllers.selected = null` from `optionsBuilder`. Traced
  Flutter's `RawAutocomplete`: it re-runs `optionsBuilder` right after `onSelected` (with the option's
  name), which was wiping the pick; the field's own `onChanged` still invalidates the pick on genuine
  user typing (programmatic controller changes don't fire `onChanged`). Bonus: qty→calorie recompute
  after selection now works too. `flutter analyze` clean.
- **Where:** `lib/features/food_nutrition/add_meal_screen.dart` (`_EntryRow` Autocomplete)
- **Cause:** `onSelected` set `controllers.selected = food`, but the field-text update re-triggered
  `optionsBuilder`, which reset `controllers.selected = null`. `_buildEntries` reads `e.selected` for
  protein/carbs/fat.
- **Failure scenario:** picking a catalog food logged calories (from the text field) but null macros.

### 6. Create-community-group dialog leaks controllers
- [x] **Fixed** — the function already `await`s `showDialog`, so the three controllers are now
  disposed right after it returns. Their `.text` is read synchronously into `createGroup` before the
  await, so disposal can't affect an in-flight create. `flutter analyze` clean.
- **Where:** `lib/features/community/community_groups_screen.dart` (`showCreateCommunityGroupDialog`)
- **Failure scenario:** `nameCtrl`/`slugCtrl`/`descCtrl` were never disposed; 3 controllers leaked
  each time the dialog opened.

---

## P2 — Polish / minor

### 7. Dead refresh button in assessment top bar
- [x] **Fixed** — the refresh icon now triggers a confirmation-gated `_resetFlow` ("Start over"):
  clears all answers, resets the default `Cough` chip, and jumps back to step 0. `_TopBar` gained an
  optional `onReset` callback (tooltip "Start over"). `flutter analyze` clean.
- **Where:** `lib/features/health_assessment/health_assessment_flow_screen.dart` (`_TopBar`, `_resetFlow`)

### 8. Placeholder help sheets echo the label
- [x] **Fixed** — the `row` helper now takes distinct `sheetTitle`/`sheetBody`; both info links show
  real copy ("About this assessment" and "Why we ask") explaining what's collected and why, with a
  non-diagnostic disclaimer. `flutter analyze` clean.
- **Where:** `lib/features/health_assessment/health_assessment_flow_screen.dart` (`_BottomInfoLinks`)
- **Failure scenario:** both info links opened a bottom sheet whose title *and* body were just the
  link label repeated.

### 9. "their blood type" copy when subject is Myself
- [x] **Fixed** — `_BloodTypePage` now takes the `subject` and shows "What is **your** blood type?"
  for Myself vs "What is **their** blood type?" for Someone else. `flutter analyze` clean.
- **Where:** `lib/features/health_assessment/health_assessment_flow_screen.dart` (`_BloodTypePage`)
- **Note:** other steps still use second-person "you/your" regardless of subject; a full
  subject-aware copy pass is out of scope for this item.

### 10. Inconsistent chat "more" affordance
- [x] **Fixed** — the "more" button now pushes the same `UserDetailScreen` as the avatar tap (builds a
  `SuggestedPeer` from the current `ChatUser`, `int.tryParse` guarded). No more "coming soon" for a
  feature that already exists. `flutter analyze` clean.
- **Where:** `lib/features/chat/chat_screen.dart` (`more` callback)

### 11. Chatbot: uncaught StateError if cleared mid-send
- [x] **Fixed** — `_deliver` now looks up the outgoing message with `indexWhere` (both success and
  failure paths) and bails when it's gone: the success path discards the reply instead of resurrecting
  a cleared chat; the failure path skips the "failed" update. No more uncaught `StateError`.
  `flutter analyze` clean.
- **Where:** `lib/features/chatbot/ai_assistant_provider.dart` (`_deliver`)

### 12. AI chat history is local-only
- [x] **Fixed (wired)** — when `FF_AI_ASSISTANT=true`, `load()` now fetches `GET /chat/ai/history/`
  and uses it as the authoritative base, appending any local pending/failed outgoing messages so an
  in-flight send survives reload; falls back to local history on offline/error. Also hardened
  `ChatMessage.fromApiHistoryJson`: the live endpoint returns `{role, content, timestamp}` with **no
  `id`**, which previously made every item's id the string `"null"` — now falls back to
  `role_timestamp`. Verified the live shape via a read-only GET. `flutter analyze` clean.
- **Where:** `lib/features/chatbot/ai_assistant_provider.dart` (`load`),
  `lib/features/chatbot/chatbot_models.dart` (`fromApiHistoryJson`)

---

# Round 2 — remaining feature areas (audit 2026-07-02)

Deep read of the previously-deferred areas (done inline, no subagents). Health/medication providers
and the vitals/goals form screens are solid (proper dispose, validation, mounted guards, loading/error
states). Medication search works (controller listener filters the list). Findings below are **not yet
fixed** — ordered by priority.

## Progress (round 2)

| # | Priority | Area | Item | Status |
|---|---|---|---|---|
| 13 | P1 | Subscription | Screen never loads live data (`load()` uncalled) | ✅ |
| 14 | P1 | Subscription | Main "Next" button is dead (no action) | ✅ |
| 15 | P2 | Subscription | Payment-method buttons non-selectable (`checker: null`) | ⏳ Deferred (payment gateway) |
| 16 | P2 | Subscription | Checkout totals hardcoded, not from plan | ⏳ Deferred (payment gateway) |
| 17 | P2 | Subscription | `SubscriptionFinishScreen.routeName` mislabeled | ✅ |
| 18 | P3 | Profile | Dead `GestureDetector(onTap: (){})` around a field | ✅ |
| 19 | P3 | Health | `fetchSymptoms()` not wrapped in `_safe` in `load()` | ✅ |

> **Context:** the payment *gateway* flow was explicitly deferred earlier (GAP_FIX_PLAN Branch 3e).
> Items 15–16 are part of that deferral; 13, 14, 17 are distinct defects independent of the gateway.

### 13. Subscription screen never loads live data
- [x] **Fixed** — converted `SubscriptionAndPaymentScreen` to a `StatefulWidget` and call
  `SubscriptionProvider.load()` in a post-frame callback on mount (idempotent), so `premiumPlan`/price
  now come from the backend (hardcoded value remains only as a pre-load fallback). `flutter analyze` clean.
- **Where:** `lib/features/subscription/subscription_and_payment_screen.dart`

### 14. Subscription main "Next" button is dead
- [x] **Fixed** — the bottom "Next" `Button` now has a `buttonAction`: it selects the premium plan
  (`premiumPlan?.id ?? 'premium'`) and pushes `PaymentMethodScreen`, matching the price button.
  `flutter analyze` clean.
- **Where:** `lib/features/subscription/subscription_and_payment_screen.dart`

### 15. Payment-method buttons non-selectable
- [ ] ⏳ **Deferred** — part of the payment-gateway flow (GAP_FIX_PLAN Branch 3e). Needs real
  payment-method selection state before wiring `checker`.
- **Where:** `subscription_and_payment_screen.dart` — all three `PaymentMethodButtons` pass
  `checker: null`; `isChecked` is read-only from `paymentInfo`.

### 16. Checkout totals are hardcoded
- [ ] ⏳ **Deferred** — part of the payment-gateway flow. Totals should derive from the selected
  plan/payment amount once the gateway is implemented.
- **Where:** `subscription_and_payment_screen.dart` — Subtotal `24.42$`, TAX `1.57$`, Total `25.99$`
  are literals.

### 17. `SubscriptionFinishScreen.routeName` mislabeled
- [x] **Fixed** — renamed `routeName` from `"/ForgotPasswordEmailCheck"` to `"/subscription-finish"`
  (it was unused by named routing; navigation is via `MaterialPageRoute`). `flutter analyze` clean.
- **Where:** `subscription_and_payment_screen.dart`

### 18. Dead GestureDetector around a profile field
- [x] **Fixed** — removed the no-op `GestureDetector(onTap: () {})` wrapper; the `TextFormField`
  (which handles its own taps) is now a direct child of the `SizedBox`. `flutter analyze` clean.
- **Where:** `lib/features/profile/personal_information_screen.dart`

### 19. `fetchSymptoms()` not best-effort in HealthProvider.load
- [x] **Fixed** — `fetchSymptoms()` is now wrapped in `_safe(...)` like the other loads, so a
  non-`ApiException` no longer escapes `load()` and leaves `_loadStarted` stuck true. `flutter analyze` clean.
- **Where:** `lib/features/health/health_provider.dart`

---

## Coverage & remaining areas

Round 1 — directly reviewed: **home, health-assessment flow, private chat, group chat, chatbot,
community (groups + provider), nutrition add-meal**.

Round 2 — reviewed:
- [x] `lib/features/subscription/*` (provider + full payment screen) — findings 13–17
- [x] `lib/features/health/*` providers + `log_vital`/`add_goal` forms — clean (finding 19 minor)
- [x] `lib/features/medication/*` provider + list/search — clean (search works via controller listener)
- [x] `lib/features/profile/contacts_provider.dart` — clean; spot-checks on profile screens (finding 18)

**Still not line-by-line read** (grep-swept for dead controls/TODO/coming-soon — none found beyond the
above): `profile/personal_information_screen.dart`, `emergency_contact`/`personal_doctor` detail
screens, `auth/onboarding/forgot_password` (partly validated in commit `62b703e`),
`health/health_dashboard_screen.dart`, `symptom_tracking_screen.dart`, `ads/*`.

Cross-cutting checks a follow-up pass should also run: dark-mode/theming, ScreenUtil vs
`MediaQuery` sizing consistency, error-toast consistency, list keys/perf, image caching.
