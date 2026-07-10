import 'package:mat_app/app/core/config/access_policy_config.dart';
import 'package:mat_app/app/core/models/usage_gate_decision.dart';
import 'package:mat_app/app/core/models/user_access_state.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';

class UsageGateService {
  const UsageGateService({
    this.config = const AccessPolicyConfig(),
  });

  final AccessPolicyConfig config;

  UsageGateDecision evaluate(
    PrimeCalculationRequest request,
    UserAccessState accessState,
  ) {
    final intervalLength = request.intervalLength;

    if (intervalLength > config.proMaxRange) {
      return UsageGateDecision(
        action: UsageGateAction.requirePremium,
        allowedRangeMax: config.proMaxRange,
        message:
            'Esse intervalo excede o limite maximo do app. Tente ate ${config.proMaxRange} numeros por consulta.',
      );
    }

    if (accessState.isPremium) {
      return const UsageGateDecision(action: UsageGateAction.allow);
    }

    if (accessState.hasTemporaryExpandedAccess) {
      if (intervalLength <= config.freeMaxRangeRewarded) {
        return const UsageGateDecision(action: UsageGateAction.allow);
      }

      return UsageGateDecision(
        action: UsageGateAction.requirePremium,
        allowedRangeMax: config.freeMaxRangeRewarded,
        message:
            'Seu acesso expandido cobre consultas de ate ${config.freeMaxRangeRewarded} numeros. Para ir alem disso, use o MatApp Pro.',
      );
    }

    if (intervalLength <= config.freeMaxRangeSoft) {
      return const UsageGateDecision(action: UsageGateAction.allow);
    }

    if (intervalLength <= config.freeMaxRangeRewarded) {
      return UsageGateDecision(
        action: UsageGateAction.requireRewardedAccess,
        allowedRangeMax: config.freeMaxRangeRewarded,
        message:
            'Esse intervalo passa do limite gratuito de ${config.freeMaxRangeSoft} numeros. Libere um acesso expandido para consultar ate ${config.freeMaxRangeRewarded} numeros.',
      );
    }

    return UsageGateDecision(
      action: UsageGateAction.requirePremium,
      allowedRangeMax: config.proMaxRange,
      message:
          'Esse intervalo exige o MatApp Pro. No plano gratuito, consultas diretas vao ate ${config.freeMaxRangeSoft} numeros e o acesso expandido cobre ate ${config.freeMaxRangeRewarded}.',
    );
  }
}
