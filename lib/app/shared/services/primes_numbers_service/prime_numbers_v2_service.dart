import 'dart:math';

import 'package:flutter/foundation.dart';

class PrimeNumberV2Service {
  List<int> calculatePrimes(int a, int b) {
    List<int> result = [2, 3, 5].where((x) => x >= a && x <= b).toList();

    // Calculando os primos básicos Pb <= sqrt(b)
    List<int> basicPrimes = _getBasicPrimes(b);

    // Aplicação da Fórmula 1 para gerar candidatos
    List<int> candidates = _formula1(a, b);

    // Aplicação da Fórmula 2 para remover múltiplos dos primos básicos
    List<int> primes = _formula2(candidates, basicPrimes);

    result.addAll(primes);

    result.sort((a, b) => a.compareTo(b));

    if(kDebugMode){
      print(result);
    }

    return result;
  }

  List<int> _getBasicPrimes(int b) {
    int sqrtB = sqrt(b).toInt();
    List<int> primes = [];

    for (int i = 2; i <= sqrtB; i++) {
      if (_isPrime(i)) {
        primes.add(i);
      }
    }
    return primes;
  }

  List<int> _formula1(int a, int b) {
    List<int> candidates = [];
    List<int> ts = [7, 11, 13, 17, 19, 23, 29, 31]; // t1, t3, t7 e t9

    for (var t in ts) {
      for (int n = 0; 30 * n + t <= b; n++) {
        int value = 30 * n + t;
        if (value >= a) {
          candidates.add(value);
        }
      }
    }
    return candidates;
  }

  List<int> _formula2(List<int> candidates, List<int> basicPrimes) {
    Set<int> nonPrimes = {};

    for (var prime in basicPrimes) {
      int multiple = prime * prime;
      while (multiple <= candidates.last) {
        nonPrimes.add(multiple);
        multiple += prime;
      }
    }

    return candidates.where((x) => !nonPrimes.contains(x)).toList();
  }

  bool _isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i <= sqrt(n).toInt(); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }
}
