import 'package:flutter/foundation.dart';
import 'package:mat_app/app/core/models/usage_gate_decision.dart';
import 'package:mat_app/app/core/models/user_access_state.dart';
import 'package:mat_app/app/core/exceptions/input_validation_exception.dart';
import 'package:mat_app/app/core/services/usage_gate_service.dart';
import 'package:mat_app/app/core/stores/user_access_store.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_request.dart';
import 'package:mat_app/app/module/prime_numbers/domain/entities/prime_calculation_result.dart';
import 'package:mat_app/app/module/prime_numbers/domain/services/prime_number_calculator.dart';

class PrimeNumbersStore extends ChangeNotifier {
  PrimeNumbersStore(
    this._calculator,
    this._usageGateService,
    this._userAccessStore,
  ) {
    _userAccessStore.addListener(_handleAccessStateChanged);
  }

  final PrimeNumberCalculator _calculator;
  final UsageGateService _usageGateService;
  final UserAccessStore _userAccessStore;

  String _startText = '';
  String _endText = '';
  bool _isLoading = false;
  String? _inputError;
  String? _calculationError;
  PrimeCalculationResult? _result;

  String get startText => _startText;
  String get endText => _endText;
  bool get isLoading => _isLoading;
  String? get inputError => _inputError;
  String? get calculationError => _calculationError;
  PrimeCalculationResult? get result => _result;
  bool get hasResult => _result != null;
  bool get canSubmit => !_isLoading;
  UserAccessState get accessState => _userAccessStore.state;

  String get currentPlanLabel {
    switch (_userAccessStore.state.plan) {
      case UserPlan.free:
        return 'Gratuito';
      case UserPlan.rewarded:
        return 'Acesso expandido';
      case UserPlan.pro:
        return 'Pro';
    }
  }

  int? get currentIntervalLength {
    final start = int.tryParse(_startText.trim());
    final end = int.tryParse(_endText.trim());

    if (start == null || end == null || start > end) {
      return null;
    }

    return (end - start) + 1;
  }

  UsageGateDecision? get gatePreviewDecision {
    final start = int.tryParse(_startText.trim());
    final end = int.tryParse(_endText.trim());

    if (start == null || end == null || start < 0 || end < 0 || start > end) {
      return null;
    }

    return _usageGateService.evaluate(
      PrimeCalculationRequest(start: start, end: end),
      _userAccessStore.state,
    );
  }

  String? get gatePreviewMessage {
    final decision = gatePreviewDecision;
    if (decision == null) {
      return null;
    }

    if (decision.isAllowed) {
      return 'Consulta disponivel para o plano atual.';
    }

    return decision.message;
  }

  void updateStart(String value) {
    _startText = value;
    _inputError = null;
    _calculationError = null;
    notifyListeners();
  }

  void updateEnd(String value) {
    _endText = value;
    _inputError = null;
    _calculationError = null;
    notifyListeners();
  }

  void activateSimulatedRewardedAccess() {
    _userAccessStore.activateRewardedAccess();
  }

  void activateSimulatedProAccess() {
    _userAccessStore.activatePro();
  }

  void resetAccessToFree() {
    _userAccessStore.resetToFree();
  }

  String? validateInputs() {
    if (_startText.trim().isEmpty || _endText.trim().isEmpty) {
      return 'Informe os dois numeros do intervalo.';
    }

    final start = int.tryParse(_startText.trim());
    final end = int.tryParse(_endText.trim());

    if (start == null || end == null) {
      return 'Use apenas numeros inteiros validos.';
    }

    if (start < 0 || end < 0) {
      return 'O intervalo nao pode conter numeros negativos.';
    }

    if (start > end) {
      return 'O valor inicial deve ser menor ou igual ao valor final.';
    }

    return null;
  }

  Future<bool> submit() async {
    final validationMessage = validateInputs();
    if (validationMessage != null) {
      _inputError = validationMessage;
      notifyListeners();
      return false;
    }

    final request = PrimeCalculationRequest(
      start: int.parse(_startText.trim()),
      end: int.parse(_endText.trim()),
    );

    final gateDecision = _usageGateService.evaluate(
      request,
      _userAccessStore.state,
    );

    if (!gateDecision.isAllowed) {
      _inputError =
          gateDecision.message ?? 'Este intervalo exige um tipo de acesso maior.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _inputError = null;
    _calculationError = null;
    notifyListeners();

    try {
      _result = await _calculator.calculate(request);
      return true;
    } on InputValidationException catch (error) {
      _inputError = error.message;
      return false;
    } catch (error) {
      _calculationError = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResult() {
    _result = null;
    _inputError = null;
    _calculationError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _userAccessStore.removeListener(_handleAccessStateChanged);
    super.dispose();
  }

  void _handleAccessStateChanged() {
    notifyListeners();
  }
}
