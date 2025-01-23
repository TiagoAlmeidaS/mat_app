import 'package:mat_app/app/shared/services/number_validator.dart';

class FixedNumberGenerator {
  final NumberValidator validator;

  FixedNumberGenerator(this.validator);

  Map<String, int> generateFixedNumbers(int rangeA, int rangeB) {
    final Map<String, String> terminacoes = {
      't1': '1',
      't3': '3',
      't7': '7',
      't9': '9'
    };
    final Map<String, int> tabelaFixa = {};

    terminacoes.forEach((key, terminacao) {
      int value = rangeA < 7 ? 7 : rangeA;

      while (!validator.endsWith(value, terminacao) || value == 1) {
        value++;
        if (!validator.isPrime(value) && validator.endsWith(value, terminacao)) {
          value++;
        }
      }

      tabelaFixa[key + '1'] = value;

      int nextValue = value + 10;
      while (!validator.isPrime(nextValue)) {
        nextValue += 10;
      }

      tabelaFixa[key + '2'] = nextValue;
    });

    print("Tabela fixa: $tabelaFixa");
    return tabelaFixa;
  }
}