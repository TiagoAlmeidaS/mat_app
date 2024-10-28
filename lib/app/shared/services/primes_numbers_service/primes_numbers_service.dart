import 'dart:math';
import 'package:flutter/foundation.dart';

class PrimesNumberService {
  /// Gera a lista completa de números primos entre [start] e [end].
  List<int> listPrimesNumbers(int start, int end) {
    List<int> rangePrimos = formula1(numerosFixos(rangeA: start, rangeB: end), end);

    // Inclui 2, 3 e 5 manualmente se o intervalo cobrir esses números
    if (start <= 2 && end >= 2) rangePrimos.add(2);
    if (start <= 3 && end >= 3) rangePrimos.add(3);
    if (start <= 5 && end >= 5) rangePrimos.add(5);

    // Filtra e mantém apenas os números primos validados
    List<int> primosValidados = rangePrimos
        .where((number) => validadorNumeroPrimo(number))
        .toList();

    // Ordena a lista final de primos
    primosValidados.sort((a, b) => a.compareTo(b));

    if(kDebugMode){
      print(primosValidados);
    }

    return primosValidados;
  }

  /// Implementa a lógica da Fórmula 1: Gera candidatos a primos.
  List<int> formula1(Map<String, int> numerosFixos, int rangeB) {
    List<int> primosECompostosPrimazes = [];

    // Gera os números candidatos a partir da fórmula 30n + t
    numerosFixos.forEach((key, value) {
      for (int n = 0; (30 * n) + value <= rangeB; n++) {
        int result = (30 * n) + value;

        // Adiciona o número se não for múltiplo de 2, 3, ou 5, e não duplicado
        if (result % 2 != 0 &&
            result % 3 != 0 &&
            result % 5 != 0 &&
            !primosECompostosPrimazes.contains(result)) {
          primosECompostosPrimazes.add(result);
        }
      }
    });

    return primosECompostosPrimazes;
  }

  /// Valida se um número é primo.
  bool validadorNumeroPrimo(int numero) {
    if (numero < 2) return false;
    if (numero == 2 || numero == 3 || numero == 5) return true;
    if (numero % 2 == 0 || numero % 3 == 0 || numero % 5 == 0) return false;

    // Verifica divisibilidade até a raiz quadrada do número
    for (int i = 7; i <= sqrt(numero).toInt(); i += 2) {
      if (numero % i == 0) return false;
    }

    return true;
  }

  /// Gera os primos básicos até a raiz quadrada do limite superior.
  List<int> numerosPrimosBasicos(int rangeB) {
    List<int> primosBasicos = [2, 3, 5];

    for (int i = 7; i <= sqrt(rangeB).toInt(); i++) {
      if (validadorNumeroPrimo(i)) {
        primosBasicos.add(i);
      }
    }

    return primosBasicos;
  }

  /// Define os números fixos terminando em 1, 3, 7 e 9 para a fórmula.
  Map<String, int> numerosFixos({required int rangeA, required int rangeB}) {
    Map<String, int> tabelaFixa = {};
    List<String> terminacoes = ['1', '3', '7', '9'];

    for (String terminacao in terminacoes) {
      int value = rangeA;

      // Encontra o primeiro número com a terminação correta que seja primo
      while (!value.toString().endsWith(terminacao) || !validadorNumeroPrimo(value)) {
        value++;
      }

      tabelaFixa[terminacao + '1'] = value;

      // Encontra o próximo número com a mesma terminação e também primo
      int nextValue = value + 10;
      while (!validadorNumeroPrimo(nextValue)) {
        nextValue += 10;
      }

      tabelaFixa[terminacao + '2'] = nextValue;
    }

    return tabelaFixa;
  }
}
