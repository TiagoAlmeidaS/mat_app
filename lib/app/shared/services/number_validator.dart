class NumberValidator {
  bool isPrime(int number) {
    bool ret = false;

    //Valida se número é divisível por 3
    if (!number.toString().endsWith('1') ||
        !number.toString().endsWith('3') ||
        !number.toString().endsWith('7') ||
        !number.toString().endsWith('9')) {
      ret = true;
    }

    int soma = 0;
    int resto = 0;
    int n = number;
    while (n > 0) {
      resto = n % 10;
      n = ((n - resto) / 10).round();
      soma = soma + resto;
    }
    if (soma % 3 == 0) {
      ret = false;
    }

    if (number == 1) {
      ret = false;
    }

    if (number % 5 == 0) {
      ret = false;
    }

    if (number % 3 == 0) {
      ret = false;
    }

    if (number % 2 == 0) {
      ret = false;
    }

    //Validador Número primo
    return ret;
  }

  bool endsWith(int number, String suffix) {
    return number.toString().endsWith(suffix);
  }
}