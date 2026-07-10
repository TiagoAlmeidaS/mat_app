enum UserPlan { free, rewarded, pro }

class UserAccessState {
  const UserAccessState({
    required this.plan,
    this.rewardedAccessExpiresAt,
  });

  const UserAccessState.free()
      : plan = UserPlan.free,
        rewardedAccessExpiresAt = null;

  final UserPlan plan;
  final DateTime? rewardedAccessExpiresAt;

  bool get isPremium => plan == UserPlan.pro;

  bool get hasTemporaryExpandedAccess {
    if (plan != UserPlan.rewarded || rewardedAccessExpiresAt == null) {
      return false;
    }

    return rewardedAccessExpiresAt!.isAfter(DateTime.now());
  }

  UserAccessState copyWith({
    UserPlan? plan,
    DateTime? rewardedAccessExpiresAt,
  }) {
    return UserAccessState(
      plan: plan ?? this.plan,
      rewardedAccessExpiresAt:
        rewardedAccessExpiresAt ?? this.rewardedAccessExpiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserAccessState &&
        other.plan == plan &&
        other.rewardedAccessExpiresAt == rewardedAccessExpiresAt;
  }

  @override
  int get hashCode => Object.hash(plan, rewardedAccessExpiresAt);
}
