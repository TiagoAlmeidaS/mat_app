import 'package:mat_app/app/shared/services/number_validator.dart';

class FixedNumberGenerator {
  final NumberValidator validator;

  FixedNumberGenerator(this.validator);

  Map<String, int> generateFixedNumbers(int rangeA, int rangeB) {
    Map<String, String> terminacoes = Map<String, String>();
    terminacoes['t1'] = '1';
    terminacoes['t3'] = '3';
    terminacoes['t7'] = '7';
    terminacoes['t9'] = '9';
    Map<String, int> tabelaFixa = {};

    terminacoes.forEach((key, terminacao) {
      int value = rangeA;
      while (value.toString().endsWith(terminacao) == false) {
        value++;
        if (validator.isPrime(value) == false &&
            value.toString().endsWith(terminacao) == true) {
          value++;
        }
      }
      tabelaFixa[key + '1'] = value;
      int nextValue = value + 10;
      while (validator.isPrime(nextValue) == false) {
        nextValue = nextValue + 10;
      }
      tabelaFixa[key + '2'] = nextValue;
    });

    return tabelaFixa;
  }
}