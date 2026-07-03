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

# Round 3 — cross-cutting sweep (5-dimension subagent audit, 2026-07-03)

Adversarial subagent sweep over 5 cross-cutting dimensions (theming, sizing, errors, lists, images):
20 raw findings → **8 confirmed, 3 plausible, 9 refuted**. (The verifier refuted the "most colors are
intentional" and "constraints.biggest is safe" notes — those were finders confirming *non*-issues —
plus several low/enhancement items.) Synthesis + completeness-critic didn't run (session limit), so
this section is synthesized by hand from the surviving findings. **None fixed yet** — priority-ordered.
All items assume the flag/screen is actually reached; theming items only bite in **dark mode**.

## Progress (round 3)

| # | Pri | Dim | Item | Status |
|---|---|---|---|---|
| 20 | P1 | Theme | Onboarding/personal-info text invisible in dark mode | ✅ |
| 21 | P1 | Errors | ~10 screens ignore provider `error` status (blank/empty instead of retry) | ✅ |
| 22 | P1 | Sizing | `size.height * x` for gaps/app-bars/call-screens → huge gaps & overflow | ✅ |
| 23 | P2 | Theme | Community User-Detail panel unreadable in dark mode | ✅ |
| 24 | P2 | Theme | Auth signup/login labels low-contrast in dark mode | ✅ |
| 25 | P2 | Theme | Shared `CustomAppBar` hardcodes white bar + dark title | ❌ Not a bug |
| 26 | P2 | Lists | Keyless stateful `CommentCard` rows → expand-state binds to wrong comment | ✅ |
| 27 | P2 | Images | Article images have no error fallback (`DecorationImage` can't show one) | ◑ Partial |
| 28 | P2 | Errors | Join/Leave group failures are silent (optimistic update never reverts) | ✅ |
| 29 | P2 | Errors | Failed peer-chat messages show "Failed" but no retry (chatbot has retry) | ⬜ |
| 30 | P3 | Errors | Load catches discard `ApiException.userMessage` (generic text only) | ⬜ |
| 31 | P3 | Errors | No shared error-snackbar helper (~29 ad-hoc `SnackBar`s, dup strings) | ⬜ |
| 32 | P3 | Sizing | Widths sized from screen **height** (wrong axis) — landscape/tablet ⚠️plausible | ⬜ |
| 33 | P3 | Images | No persistent image cache (`cached_network_image` absent) — re-downloads | ⬜ |
| 34 | P3 | Images | No loading placeholder on network images (blank avatar/hero) | ⬜ |
| 35 | P3 | Sizing | Keyboard shrinks percentage-sized forms; `resizeToAvoidBottomInset` inconsistent | ⬜ |
| 36 | P3 | Lists | Chatbot transcript uses `ListView(children:[...])` not `.builder` (perf) | ⬜ |
| 37 | P3 | Sizing | ScreenUtil setup is effectively dead (~4 uses); no single scaling strategy | ⬜ |

> **Not bugs** (verifier-refuted, recorded so they aren't re-flagged): most `Colors.white`/brand-blue
> literals are intentional fixed colors (white text on colored buttons/headers/snackbars); the
> `LayoutBuilder(constraints.biggest)` usages are all top-level under a bounded Scaffold body, so
> there's no infinite/zero-constraint trap.

### 20. Onboarding / personal-info text invisible in dark mode  ✅ Fixed
- [x] **Fixed** — pinned the onboarding data-entry screens to a light background
  (`backgroundColor: Colors.white`) so their dark labels/unit captions/RulerPicker digits stay readable
  regardless of OS theme: `initial_info_1.dart` (:57), `initial_info_4.dart` (:42),
  `get_started_screen.dart` (:58). These are a deliberately light-themed flow (dark text + the white
  `CustomAppBar` throughout), so pinning the surface is the low-risk complete fix rather than migrating
  ~50 hardcoded literals. `flutter analyze` clean (baseline unchanged).
- **Remaining:** `initial_info_2.dart` uses a `Colors.transparent` Scaffold (3 dark literals) — left as-is
  pending a look at what renders behind it. A full theme-color migration (use `cs.onSurface`/
  `onSurfaceVariant`, feed RulerPicker theme colors) is the alternative if these screens should honor
  dark mode.

### 21. ~10 screens never render provider `error` state  ◑ Partial
- [x] **Done:** added a shared `lib/core/widgets/error_retry_view.dart` (`ErrorRetryView`) and wired it
  into the screens whose providers actually enter an error state — `notifications_screen.dart` and
  `article_screen.dart` (added `ArticleProvider.refresh()`). Load failure now shows an error + Retry
  instead of a misleading empty state.
- [x] **Also done:** `community_hub_screen.dart` — For-You and People tabs now show `ErrorRetryView` on
  error (retry via `CommunityProvider.load()`, which is re-runnable — it guards on a `_loading` flag that
  resets in `finally`).
- **Left by design:** the chat list (`general_chat_screen.dart`) keeps its tabbed/search layout and
  caches conversations locally, so it's far less prone to the misleading-empty case — a full-screen
  error view there would be invasive for little gain. (After fix #19, `HealthProvider` rarely enters
  `error`, so its dashboard was intentionally skipped.)

### 22. Full-screen-height percentages for gaps / app-bars / call screens  ◑ Partial
- [x] **Done:** replaced the three `SizedBox(height: size.height * 0.2)` group separators in
  `chat/general_chat_screen.dart` (~170px dead gaps between chat groups) with a fixed `12`px — the
  highest-traffic, clearest breakage.
- [x] **Also done:** the call screens (`audio_call_screen.dart`, `vidoe_call_screen.dart`) — replaced the
  `size.height * 0.55`/`0.53` spacers with `Spacer()` (no more overflow on short/landscape), and removed
  an invalid `Expanded` inside their `Stack` (it threw a `ParentDataWidget` error — the call screens were
  effectively broken on open).
- **Left (minor):** chat/group app-bar `preferredSize` height `size.height*0.15` (only oversized on
  tablets; fixing it cleanly also requires converting the app-bar's `size.height*0.06` avatar/content to
  fixed sizes, else they'd overflow a fixed bar). Low impact on phones — deferred.

### 23. Community User-Detail panel unreadable in dark mode  ✅ Fixed
- [x] **Fixed** — themed `chat/user_detail_screen.dart`: name/subtitle → `cs.onSurface`/
  `onSurfaceVariant`; TabBar `unselectedLabelColor` → `cs.onSurfaceVariant`; `InfoBuilder` field
  label/value → theme colors; the shared tab-placeholder now takes `context` and uses
  `cs.onSurfaceVariant`; header tint → `cs.surfaceContainerHighest`. (Left the avatar white ring, the
  'Community' badge on its blue-gradient chip, and the switch track tints — intentional fixed/decorative
  colors.) `flutter analyze` clean.

### 24. Auth signup/login labels low-contrast in dark mode  ✅ Fixed
- [x] **Fixed** — themed the 7 dark-text literals in `onboarding/signup_and_login_screen.dart`
  (account-message, "Or", "Didn't receive an email?", input hint, T&C RichText spans, bottom action
  text) to `cs.onSurfaceVariant`/`cs.onSurface`. Kept the theme approach rather than pinning light,
  because the screen has a white-by-design Google sign-in button (`IconContainor`) that would blend on a
  white background. `flutter analyze` clean.

### 25. Shared `CustomAppBar` hardcodes white bar + dark title  ❌ Not a bug (mis-attributed)
- [x] **Investigated — no fix needed.** The shared `lib/widget/custom_app_bar_title.dart` (white bar) is
  imported by **only `get_started_screen`** — a light-flow screen already pinned white in #20, so the
  white bar is correct/consistent there. The `article_detail`/`article_comment`/`gadgets` "CustomAppBar"
  references are **separate classes** (each defined in its own file), not this shared widget. The finder
  over-counted via the class-name collision.

### 26. Keyless stateful `CommentCard` rows → wrong expand state  ✅ Fixed
- [x] **Fixed** — added `key: ValueKey(c.id)` to the `CommentCard` in the article-comments
  `ListView.builder`, so expand state stays bound to its comment after the list is replaced.

### 27. Article images have no error fallback  ◑ Partial
- [x] **Done:** the article feed thumbnail (`article_screen.dart`) now has an `errorBuilder` → bundled
  asset fallback when the network image fails.
- [ ] **Remaining:** the detail (`article_detail_screen.dart:86`) and comment
  (`article_comment_screen.dart:132`) heroes still use `DecorationImage` (which can't take an
  `errorBuilder`). They need a `Stack` + `Positioned.fill(Image(errorBuilder:))` restructure (the
  closing brace is far from the opening, so it was deferred rather than risk a mis-matched edit).

### 28. Join / Leave group failures are silent  ✅ Fixed
- [x] **Fixed** — community group Join/Leave now go through a `_membership` helper that awaits the
  action and shows a SnackBar on failure. (No optimism to revert: the provider only mutates state after
  a successful await.)
- [ ] **Remaining (minor):** the chat-group join in `general_chat_screen.dart` still lacks the same
  wrapper.

### 29. Failed peer-chat messages have no retry  ⚠️plausible
- [ ] **Fix** — `chat_screen.dart:504` & `group_chat_screen.dart:481` show a "Failed" label with no tap
  handler, whereas `chatbot_screen.dart:327` offers "tap to retry". Add a resend on tap mirroring
  `AiAssistantProvider.retry`. (Verifier for this dimension didn't run — confirm on device.)

### 30. Load catches discard `ApiException.userMessage`  ⚠️plausible
- [ ] **Fix** — `article_provider.dart:27`, `notification_provider.dart:34`, `chat_provider.dart:241`,
  `community_provider.dart:68`, `nutrition_provider.dart:33` use bare `catch (_)` and store no message,
  so even error branches show generic text. Catch `on ApiException catch (e)` and store `e.userMessage`.

### 31. No shared error-snackbar helper  ℹ️ (P3, refactor)
- [ ] **Fix** — ~29 inline `SnackBar(content: Text(...))` sites with ~18 near-duplicate "Could not X.
  Try again." strings; only one local helper exists. Add a `context.showErrorSnack(ApiException)`
  extension and route action failures through it.

### 32. Widths sized from screen **height** (wrong axis)  ⚠️plausible
- [ ] **Fix** — `chat/user_detail_screen.dart:311` (`width: size.height * 0.23` for a text column),
  `chat_screen.dart:189-190`, `group_chat_screen.dart:162`, `public_profile_screen.dart:99,:267`
  (~17 sites). On landscape/short/tablet screens these collapse or mis-proportion. Size widths from the
  width axis or use `Expanded`/`Flexible`/fixed px.

### 33. No persistent image cache  ℹ️ (P3, enhancement)
- [ ] **Fix** — `cached_network_image` absent; avatars (`core/widgets/user_avatar.dart:46`, used in
  scrolling chat/community lists) and article images re-download on cold start. Add
  `cached_network_image` and route `UserAvatar` + article images through it (also fixes #27/#34).

### 34. No loading placeholder on network images  ℹ️ (P3)
- [ ] **Fix** — `user_avatar.dart:46`, `personal_information_screen.dart:92`, article image sites have
  no `loadingBuilder` → blank circle/hero until download resolves. Add a placeholder.

### 35. Keyboard shrinks percentage-sized forms  ℹ️ (P3)
- [ ] **Fix** — `medications_screen.dart:109` leaves `resizeToAvoidBottomInset` default true while
  sizing from `constraints.biggest`, so the form contracts/reflows while typing; 8 other Scaffolds set
  it false. Pick one strategy (keyboard-independent base size, or scroll focused field into view).

### 36. Chatbot transcript uses `ListView(children:)` not `.builder`  ℹ️ (P3, perf)
- [ ] **Fix** — `chatbot_screen.dart:230` builds every bubble up-front and rebuilds all on each provider
  notify. Switch to `ListView.builder`.

### 37. ScreenUtil setup effectively dead  ℹ️ (P3, cleanup)
- [ ] **Fix** — `main.dart:182` `ScreenUtilInit(designSize:(411,852))` but only ~4 `.sp/.w` uses; fonts
  size off `screenWidth*x` (ignores text-scale/accessibility). Either commit to ScreenUtil everywhere
  or drop it and use theme text styles + `MediaQuery.textScaler`.

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

Cross-cutting checks — **done in Round 3** (dark-mode/theming, ScreenUtil vs `MediaQuery` sizing,
error-toast consistency, list keys/perf, image caching) → findings #20–#37.

Still un-swept cross-cutting concerns (the completeness-critic didn't run — session limit): text
scaling / `textScaler` accessibility, RTL / localization (the app has a language screen but strings are
hardcoded), safe-area/notch handling, minimum tap-target sizes, and first-paint/splash. Worth a
follow-up pass.
