enum UsageGateAction { allow, requireRewardedAccess, requirePremium }

class UsageGateDecision {
  const UsageGateDecision({
    required this.action,
    this.message,
    this.allowedRangeMax,
  });

  final UsageGateAction action;
  final String? message;
  final int? allowedRangeMax;

  bool get isAllowed => action == UsageGateAction.allow;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UsageGateDecision &&
        other.action == action &&
        other.message == message &&
        other.allowedRangeMax == allowedRangeMax;
  }

  @override
  int get hashCode => Object.hash(action, message, allowedRangeMax);
}
