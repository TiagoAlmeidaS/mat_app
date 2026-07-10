import 'package:flutter/foundation.dart';
import 'package:mat_app/app/core/config/access_policy_config.dart';
import 'package:mat_app/app/core/models/user_access_state.dart';

class UserAccessStore extends ChangeNotifier {
  UserAccessStore({
    this.config = const AccessPolicyConfig(),
  });

  final AccessPolicyConfig config;
  UserAccessState _state = const UserAccessState.free();

  UserAccessState get state => _state;

  void update(UserAccessState newState) {
    _state = newState;
    notifyListeners();
  }

  void activateRewardedAccess() {
    _state = UserAccessState(
      plan: UserPlan.rewarded,
      rewardedAccessExpiresAt: DateTime.now().add(
        config.rewardedAccessDuration,
      ),
    );
    notifyListeners();
  }

  void activatePro() {
    _state = const UserAccessState(
      plan: UserPlan.pro,
    );
    notifyListeners();
  }

  void resetToFree() {
    _state = const UserAccessState.free();
    notifyListeners();
  }
}
