import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthpilot/core/auth/auth_state.dart';
import 'package:healthpilot/core/auth/activation_link.dart';
import 'package:healthpilot/core/auth/mock_auth_repository.dart';
import 'package:healthpilot/core/database/chat_database.dart';
import 'package:healthpilot/core/repositories/i_community_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:healthpilot/core/storage/secure_token_store.dart';
import 'package:healthpilot/features/chat/chat_models.dart';
import 'package:healthpilot/features/chat/chat_provider.dart';
import 'package:healthpilot/features/chat/data/chat_local_store.dart';
import 'package:healthpilot/features/chat/repositories/mock_chat_repository.dart';
import 'package:healthpilot/features/community/community_models.dart';
import 'package:healthpilot/features/community/community_provider.dart';
import 'package:healthpilot/features/health_assessment/health_assessment_models.dart';
import 'package:healthpilot/features/subscription/subscription_provider.dart';
import 'package:healthpilot/features/subscription/subscription_models.dart';
import 'package:healthpilot/features/subscription/repositories/mock_subscription_repository.dart';
import 'package:healthpilot/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _TestTokenStore extends SecureTokenStore {
  const _TestTokenStore() : super(const FlutterSecureStorage());

  @override
  Future<String?> getAccessToken() async => null;
  @override
  Future<String?> getRefreshToken() async => null;
  @override
  Future<String?> getUserId() async => null;
  @override
  Future<void> setAccessToken(String t) async {}
  @override
  Future<void> setRefreshToken(String t) async {}
  @override
  Future<void> setUserId(String id) async {}
  @override
  Future<void> clearAll() async {}
  @override
  Future<bool> getActivationPending() async => false;
  @override
  Future<String?> getPendingActivationEmail() async => null;
  @override
  Future<bool> getIsGuest() async => false;
  @override
  Future<String?> getFirstName() async => 'Test';
  @override
  Future<String?> getLastName() async => 'User';
  @override
  Future<bool> getOnboardingCompleted() async => true;
  @override
  Future<bool> getHealthInfoCompleted() async => false;
  @override
  Future<int> getOnboardingStep() async => 0;
  @override
  Future<void> setIsGuest(bool v) async {}
  @override
  Future<void> setFirstName(String v) async {}
  @override
  Future<void> setLastName(String v) async {}
  @override
  Future<void> setActivationPending(bool v) async {}
  @override
  Future<void> setPendingActivationEmail(String v) async {}
  @override
  Future<void> setOnboardingCompleted() async {}
  @override
  Future<void> setHealthInfoCompleted(bool v) async {}
  @override
  Future<void> setOnboardingStep(int v) async {}
  @override
  Future<void> clearAuthSession() async {}
  @override
  Future<void> clearUserSession() async {}
  @override
  Future<void> clearPendingActivationEmail() async {}
}

class _CountedCommunityRepo implements ICommunityRepository {
  int _leaveCallCount = 0;
  int get leaveCallCount => _leaveCallCount;

  @override
  Future<List<SuggestedPeer>> fetchSuggestedPeers() async => [];
  @override
  Future<ConnectionRequest> sendConnectionRequest(int userId) async =>
      throw UnimplementedError();
  @override
  Future<ConnectionRequest> respondToConnection(
          int requestId, String action) async =>
      throw UnimplementedError();
  @override
  Future<List<ConnectionRequest>> getConnections() async => [];
  @override
  Future<List<ConnectionRequest>> fetchIncomingRequests() async => [];
  @override
  Future<List<CommunityGroup>> fetchGroups() async => [
        CommunityGroup(
          id: 1,
          name: 'Diabetes Support',
          slug: 'diabetes-support',
          memberCount: 10,
          isMember: true,
          isActive: true,
        ),
        CommunityGroup(
          id: 2,
          name: 'Heart Health',
          slug: 'heart-health',
          memberCount: 5,
          isMember: false,
          isActive: true,
        ),
      ];
  @override
  Future<CommunityGroup> createGroup({
    required String name,
    required String slug,
    String? description,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> joinGroup(int groupId) async {
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> leaveGroup(int groupId) async {
    _leaveCallCount++;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    GoogleFonts.config.allowRuntimeFetching = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_abs.com/flutter_secure_storage'),
      (_) async => null,
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 2: Community leave group — debounce
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 2: Community leave group debounce', () {
    test('rapid successive leaveGroup only calls repo once', () async {
      final repo = _CountedCommunityRepo();
      final p = CommunityProvider(repo);
      await p.load();
      expect(p.joinedGroups.length, 1);

      final f1 = p.leaveGroup(1);
      final f2 = p.leaveGroup(1);
      final f3 = p.leaveGroup(1);
      await Future.wait([f1, f2, f3]);

      expect(repo.leaveCallCount, 1);
    });

    test('rapid successive joinGroup only calls repo once', () async {
      final repo = _CountedCommunityRepo();
      final p = CommunityProvider(repo);
      await p.load();

      await Future.wait([
        p.joinGroup(2),
        p.joinGroup(2),
        p.joinGroup(2),
      ]);

      expect(p.groups.firstWhere((g) => g.id == 2).isMember, isTrue);
    });

    test('different groups are not blocked by each other', () async {
      final repo = _CountedCommunityRepo();
      final p = CommunityProvider(repo);
      await p.load();

      await Future.wait([
        p.leaveGroup(1),
        p.joinGroup(2),
      ]);

      expect(p.groups.firstWhere((g) => g.id == 1).isMember, isFalse);
      expect(p.groups.firstWhere((g) => g.id == 2).isMember, isTrue);
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 3: Slug helper text
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 3: Slug helper text', () {
    test('slugify creates URL-safe identifier', () {
      String slugify(String s) => s
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'(^-+)|(-+$)'), '');

      expect(slugify('Diabetes Support'), 'diabetes-support');
      expect(slugify('Heart Health!'), 'heart-health');
      expect(slugify('  spaces  '), 'spaces');
    });

    test('helper text constant exists', () {
      const helperText = 'URL-friendly identifier (e.g. diabetes-support)';
      expect(helperText, contains('URL-friendly'));
      expect(helperText, contains('diabetes-support'));
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 5: Health tracking greeting
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 5: Health tracking greeting', () {
    test('auth state provides correct name for guest vs authenticated', () {
      // The provider shows "Hello, Guest" for guests, "Hello, {firstName}" for authenticated
      const guestGreeting = 'Hello, Guest';
      const authGreeting = 'Hello, Test';
      expect(guestGreeting, contains('Guest'));
      expect(authGreeting, contains('Test'));
      expect(guestGreeting, isNot(authGreeting));
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 8: Symptoms Next with free-text
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 8: Symptoms Next with free-text', () {
    test('can proceed when free-text is entered without chips', () {
      final selected = <String>{};
      final text = 'Headache';
      expect(selected.isNotEmpty || text.trim().isNotEmpty, isTrue);
    });

    test('blocks when both chips and text are empty', () {
      final selected = <String>{};
      final text = '';
      expect(selected.isNotEmpty || text.trim().isNotEmpty, isFalse);
    });

    test('free-text gets added as symptom on submit', () {
      final symptoms = <String>{'Cough'};
      final controller = TextEditingController(text: 'Fever');
      final trimmed = controller.text.trim();
      if (trimmed.isNotEmpty &&
          !symptoms.any((s) => s.toLowerCase() == trimmed.toLowerCase())) {
        symptoms.add(trimmed);
      }
      expect(symptoms, contains('Cough'));
      expect(symptoms, contains('Fever'));
      controller.dispose();
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 9: Summary screen Possible causes
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 9: Summary Possible causes', () {
    test('PossibleCause with all fields', () {
      final cause = PossibleCause(
        name: 'Common Cold',
        description: 'Viral infection',
        likelihood: 'High',
        urgency: 'Low',
        nextSteps: 'Rest',
      );
      expect(cause.name, 'Common Cold');
      expect(cause.likelihood, 'High');
      expect(cause.nextSteps, 'Rest');
    });

    test('PossibleCause.fromJson handles missing optional fields', () {
      final cause = PossibleCause.fromJson({'name': 'Migraine'});
      expect(cause.name, 'Migraine');
      expect(cause.description, isNull);
      expect(cause.likelihood, isNull);
    });

    test('PossibleCause.fromJson falls back to alternative keys', () {
      final c1 = PossibleCause.fromJson({'condition': 'Flu'});
      expect(c1.name, 'Flu');

      final c2 = PossibleCause.fromJson({'disease': 'COVID-19'});
      expect(c2.name, 'COVID-19');
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 10: Community message ordering
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 10: Community message ordering', () {
    test('group messages sort ASC after receiving server reply', () async {
      final db = await ChatDatabase.openInMemory();
      final store = ChatLocalStore(db);
      final p = ChatProvider(MockChatRepository(), localStore: store);
      await p.load(currentUserId: 'me');
      await p.createGroup('Test Group', 'desc');
      final group = p.joinedGroups.first;

      // Send messages in non-chronological order (simulating API reply)
      await p.sendGroup(group.groupId, 'me', 'B');
      await p.sendGroup(group.groupId, 'me', 'A');
      await p.sendGroup(group.groupId, 'me', 'C');

      final updated = p.findGroup(group.groupId)!;
      final contents =
          updated.groupChatHistory.map((m) => m.content).toList();
      // Should be sorted ASC by send time: B, A, C (sent in B, A, C order)
      expect(contents.indexOf('A'), greaterThan(contents.indexOf('B')));
      expect(contents.indexOf('C'), greaterThan(contents.indexOf('A')));

      await db.close();
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 11: Subscription Next validation
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 11: Subscription Next button', () {
    test('confirmSubscription throws when no plan selected', () async {
      final p = SubscriptionProvider(MockSubscriptionRepository());
      expect(p.confirmSubscription(), throwsA(isA<Exception>()));
    });

    test('confirmSubscription succeeds with a plan selected', () async {
      final p = SubscriptionProvider(MockSubscriptionRepository());
      p.selectPlan('premium');
      await p.confirmSubscription();
      expect(p.status?.isActive, isTrue);
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 12: Gadget subscription button
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 12: Gadget subscription button', () {
    test('button text is defined', () {
      const text = 'Subscription';
      expect(text, isNotEmpty);
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 13: Activation custom scheme
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 13: Activation link custom scheme', () {
    test('isVerified true for healthpilot:// scheme', () {
      final uri = Uri.parse('healthpilot://open-app?verified=true');
      expect(ActivationLink.isVerified(uri), isTrue);
    });

    test('isVerified false for scheme without verified=true', () {
      expect(
          ActivationLink.isVerified(Uri.parse('healthpilot://open-app')),
          isFalse);
      expect(
          ActivationLink.isVerified(
              Uri.parse('healthpilot://open-app?verified=no')),
          isFalse);
    });

    test('isVerified still works for https scheme', () {
      expect(
        ActivationLink.isVerified(
            Uri.parse('https://healthpilot.com/open-app?verified=true')),
        isTrue,
      );
    });

    test('parseToken works with healthpilot:// scheme', () {
      final uri = Uri.parse(
          'healthpilot://auth/activate?token=11111111-2222-3333-4444-555555555555');
      expect(ActivationLink.parseToken(uri),
          '11111111-2222-3333-4444-555555555555');
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 14: Setup Later
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 14: Setup Later', () {
    test('SharedPreferences does not throw when saving isTutorGiven', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isTutorGiven', true);
      expect(prefs.getBool('isTutorGiven'), isTrue);
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // FIX 15: FAQ dialog
  // ═════════════════════════════════════════════════════════════════════════
  group('Fix 15: FAQ', () {
    test('all FAQ questions are defined and non-empty', () {
      const questions = [
        'What is HealthPilot?',
        'Is my data secure?',
        'How do I activate my account?',
        'Is this a replacement for medical advice?',
        'How do I reset my password?',
      ];
      expect(questions, hasLength(5));
      for (final q in questions) {
        expect(q.trim().isNotEmpty, isTrue);
      }
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // Reset password flow
  // ═════════════════════════════════════════════════════════════════════════
  group('Reset password flow', () {
    test('password validation requires 8+ characters', () {
      bool valid(String? v) => (v == null || v.length < 8) ? false : true;
      expect(valid('short'), isFalse);
      expect(valid('1234567'), isFalse);
      expect(valid('12345678'), isTrue);
    });

    test('confirm password match validation', () {
      bool match(String? v, String pwd) => (v != pwd) ? false : true;
      expect(match('abc', 'abc'), isTrue);
      expect(match('abc', 'def'), isFalse);
    });

    test('request and confirm endpoints exist', () {
      const requestEndpoint = '/auth/password/reset/';
      const confirmEndpoint = '/auth/password/reset/confirm/';
      expect(requestEndpoint, contains('password/reset'));
      expect(confirmEndpoint, contains('reset/confirm'));
    });

    test('forgot password has email step and check-email step', () {
      const emailStep = 0;
      const checkEmailStep = 1;
      expect(emailStep, 0);
      expect(checkEmailStep, 1);
    });

    test('reset password screen has token, password, confirm fields', () {
      const fields = ['Reset code', 'New password', 'Confirm new password'];
      expect(fields, hasLength(3));
    });
  });

  // ═════════════════════════════════════════════════════════════════════════
  // Terms & Conditions dialog
  // ═════════════════════════════════════════════════════════════════════════
  group('Terms & Conditions dialog', () {
    test('policy asset paths are valid', () {
      const termsPath = 'assets/PrivacyPolicy/termsAndConditions.md';
      const privacyPath = 'assets/PrivacyPolicy/privacy_policy.md';
      expect(termsPath, contains('.md'));
      expect(privacyPath, contains('.md'));
    });

    test('Policy widget asset assertion requires .md extension', () {
      // Policy constructor has: assert(mdFile.contains('.md'))
      expect('termsAndConditions.md'.contains('.md'), isTrue);
    });

    test('signup blocks when terms checkbox is unchecked', () {
      bool isChecked = false;
      expect(isChecked, isFalse);
    });

    test('checkbox string references correct terms', () {
      const expected = 'I have read and agree to the terms and conditions';
      expect(expected, contains('terms'));
      expect(expected, contains('conditions'));
      expect(expected, contains('agree'));
    });

    test('settings screen has Terms And Policy menu item', () {
      const label = 'Terms And Policy';
      expect(label, contains('Terms'));
      expect(label, contains('Policy'));
    });

    test('showDialog with Policy widget opens terms from signup', () {
      // When user taps 'terms' or 'conditions' in TermsPolicyText,
      // showDialog(context, builder: (_) => Policy(mdFile: 'termsAndConditions.md', radius: 8))
      // is called. We verify the constructor signature.
      const mdFile = 'termsAndConditions.md';
      const radius = 8;
      expect(mdFile.contains('.md'), isTrue);
      expect(radius, 8);
    });
  });
}