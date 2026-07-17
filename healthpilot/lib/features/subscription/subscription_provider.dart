import 'package:flutter/foundation.dart';
import 'package:healthpilot/core/repositories/i_subscription_repository.dart';
import 'package:healthpilot/features/subscription/subscription_models.dart';

enum SubscriptionLoadStatus { idle, loading, loaded, error }

class SubscriptionProvider extends ChangeNotifier {
  final ISubscriptionRepository _repo;

  List<SubscriptionPlan> _plans = [];
  SubscriptionStatus? _status;
  SubscriptionLoadStatus _loadStatus = SubscriptionLoadStatus.idle;
  String? _selectedPlanId;
  bool _loadStarted = false;

  List<SubscriptionPlan> get plans => List.unmodifiable(_plans);
  SubscriptionStatus? get status => _status;
  SubscriptionLoadStatus get loadStatus => _loadStatus;
  bool get isPremium => _status?.isActive ?? false;

  SubscriptionPlan? get premiumPlan {
    for (final p in _plans) {
      if (p.isPremium) return p;
    }
    return null;
  }

  /// Live backend plan ids are `monthly` / `yearly`, not `premium`.
  static const defaultPaidPlanIdFallback = 'monthly';

  String get defaultPaidPlanId =>
      premiumPlan?.id ?? defaultPaidPlanIdFallback;

  SubscriptionPlan? get selectedPlan {
    final planId = _selectedPlanId ?? defaultPaidPlanId;
    for (final plan in _plans) {
      if (plan.id == planId) return plan;
    }
    return premiumPlan;
  }

  /// Maps checkout UI flags to backend `payment_method` values.
  static String paymentMethodFor({
    required bool card,
    required bool paypal,
    required bool chapa,
  }) {
    if (paypal) return 'paypal';
    if (chapa) return 'other';
    return 'credit_card';
  }

  SubscriptionProvider(this._repo);

  Future<void> load() async {
    if (_loadStarted) return;
    _loadStarted = true;
    _loadStatus = SubscriptionLoadStatus.loading;
    notifyListeners();
    try {
      _plans = await _repo.fetchPlans();
      _status = await _repo.fetchStatus();
      _loadStatus = SubscriptionLoadStatus.loaded;
    } catch (_) {
      _loadStatus = SubscriptionLoadStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void selectPlan(String planId) {
    _selectedPlanId = planId;
  }

  Future<void> confirmSubscription() async {
    final planId = _selectedPlanId ?? defaultPaidPlanId;
    if (planId.isEmpty) {
      throw Exception('No plan selected. Please go back and select a plan.');
    }
    final updated = await _repo.subscribe(planId);
    _status = updated;
    notifyListeners();
  }

  /// Creates a payment, confirms it, then activates the selected plan.
  Future<void> completeCheckout({required String paymentMethod}) async {
    final plan = selectedPlan;
    if (plan == null) {
      throw Exception('No plan selected. Please go back and select a plan.');
    }

    if (plan.priceMonthly > 0) {
      final pending = await createPayment(
        amount: plan.priceMonthly,
        paymentMethod: paymentMethod,
      );
      await confirmPayment(pending.id);
    }

    await confirmSubscription();
  }

  Future<void> cancelSubscription() async {
    await _repo.cancelSubscription();
    _status = const SubscriptionStatus(planId: 'free', isActive: false);
    notifyListeners();
  }

  // ── Payments ───────────────────────────────────────────────────────────────
  Future<Payment> createPayment({
    required double amount,
    required String paymentMethod,
  }) =>
      _repo.createPayment(amount: amount, paymentMethod: paymentMethod);

  Future<Payment> confirmPayment(int paymentId) =>
      _repo.confirmPayment(paymentId);

  Future<List<Payment>> fetchPaymentHistory() => _repo.fetchPaymentHistory();

  /// Clears in-memory state when the user logs out or switches accounts.
  void reset() {
    _plans = [];
    _status = null;
    _selectedPlanId = null;
    _loadStatus = SubscriptionLoadStatus.idle;
    _loadStarted = false;
    notifyListeners();
  }
}
