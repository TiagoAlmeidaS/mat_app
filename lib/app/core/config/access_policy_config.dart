class AccessPolicyConfig {
  const AccessPolicyConfig({
    this.freeMaxRangeSoft = 10000,
    this.freeMaxRangeRewarded = 50000,
    this.proMaxRange = 1000000,
    this.rewardedAccessDuration = const Duration(minutes: 30),
  });

  final int freeMaxRangeSoft;
  final int freeMaxRangeRewarded;
  final int proMaxRange;
  final Duration rewardedAccessDuration;
}
