import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';

class PrimesNumberService {
  // Método principal para obter números primos, adaptando por plataforma
  Future<List<int>> listPrimesNumbers(int start, int end) async {
    if (kIsWeb) {
      // Comportamento para Web
      return await _listPrimesNumbersWeb(start, end);
    } else {
      // Comportamento para Mobile/Desktop
      return await listPrimesNumbersV2(start, end);
    }
  }

  // Implementação para Web (chunking)
  Future<List<int>> _listPrimesNumbersWeb(int start, int end) async {
    List<int> primes = [];
    int chunkSize = 1000; // Processa em blocos de 1000 números

    for (int i = start; i <= end; i += chunkSize) {
      final chunkStart = i;
      final chunkEnd = (i + chunkSize - 1).clamp(chunkStart, end);

      // Processa cada bloco
      primes.addAll(_processChunk(chunkStart, chunkEnd));

      // Aguarda um frame para evitar travamento
      await Future.delayed(Duration(milliseconds: 1));
    }

    return primes;
  }

  // Método auxiliar para processar um bloco de números
  List<int> _processChunk(int start, int end) {
    List<int> primes = [];
    for (int i = start; i <= end; i++) {
      if (validadorNumeroPrimo(i)) primes.add(i);
    }
    return primes;
  }

  // Implementação para Mobile/Desktop usando Isolates
  Future<List<int>> listPrimesNumbersV2(int start, int end) async {
    final ReceivePort receivePort = ReceivePort();

    // Spawna um isolate
    await Isolate.spawn(
        _calculatePrimesInIsolate, [receivePort.sendPort, start, end]);

    // Recebe os dados do isolate
    return await receivePort.first;
  }

  void _calculatePrimesInIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    int start = args[1];
    int end = args[2];

    // Calcula os números primos
    List<int> primes = [];
    try {
      primes = await numerosPrimos(start, end);
    } catch (e) {
      print('Erro ao calcular números primos: $e. Abordando manual');
      for (int i = start; i <= end; i++) {
        if (validadorNumeroPrimo(i)) primes.add(i);
      }
    }

    // Envia os resultados de volta para o main isolate
    sendPort.send(primes);
  }

  Future<List<int>> numerosPrimos(int rangeA, int rangeB) async {
    return await compute(
      _calculateNumerosPrimos,
      {'rangeA': rangeA, 'rangeB': rangeB},
    );
  }

  List<int> _calculateNumerosPrimos(Map<String, int> params) {
    print("Iniciando fórmula...");
    int rangeA = params['rangeA']!;
    int rangeB = params['rangeB']!;
    Map<String, int> fixos = {};
    List<int> primosBasicos = [];
    Set<int> formulaUm = {};
    List<int> excluirNaoNumeroPrimo = [];

    primosBasicos = numerosPrimosBasicos(rangeB);
    fixos = numerosFixos(rangeA: rangeA, rangeB: rangeB);
    formulaUm = formula1(fixos, rangeB).toSet();

    for (int element1 in primosBasicos) {
      for (int element2 in formulaUm) {
        if (element2 % element1 == 0 && element2 > element1) {
          excluirNaoNumeroPrimo.add(element2);
        }
      }
    }

    formulaUm.removeAll(excluirNaoNumeroPrimo);

    return formulaUm.toList()..sort((a, b) => a.compareTo(b));
  }

  bool validadorNumeroPrimo(int numero) {
    bool ret = false;

    if (!numero.toString().endsWith('1') ||
        !numero.toString().endsWith('3') ||
        !numero.toString().endsWith('7') ||
        !numero.toString().endsWith('9')) {
      ret = true;
    }

    int soma = 0;
    int resto = 0;
    int n = numero;
    while (n > 0) {
      resto = n % 10;
      n = ((n - resto) / 10).round();
      soma = soma + resto;
    }
    if (soma % 3 == 0) {
      ret = false;
    }

    if (numero == 1) {
      ret = false;
    }

    if (numero % 5 == 0) {
      ret = false;
    }

    if (numero % 3 == 0) {
      ret = false;
    }

    if (numero % 2 == 0) {
      ret = false;
    }

    return ret;
  }

  List<int> numerosPrimosBasicos(int rangeB) {
    int numeroBase = 0;
    List<int> numerosBasicos = [];
    List<int> numerosAuxBasicos = [];
    List<int> removeNPrimos = [];

    numeroBase = sqrt(rangeB).round();
    if (numeroBase < 7) {
      throw Exception("Infelizmente está fora do range de cálculo.");
    }
    while (validadorNumeroPrimo(numeroBase) == false) {
      numeroBase--;
    }

    for (int numeroAux = numeroBase; numeroAux >= 7; numeroAux--) {
      if (validadorNumeroPrimo(numeroAux) == true) {
        numerosAuxBasicos.add(numeroAux);
      }
    }

    numerosBasicos = numerosAuxBasicos;

    numerosAuxBasicos.forEach((e1) {
      numerosAuxBasicos.forEach((e2) {
        if (e1 % e2 == 0 && numerosBasicos.contains(e1) && e1 > e2) {
          removeNPrimos.add(e1);
        }
      });
    });

    removeNPrimos.forEach((element) => numerosBasicos.remove(element));

    return numerosBasicos;
  }

  Map<String, int> numerosFixos({required int rangeA, required int rangeB}) {
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
        if (validadorNumeroPrimo(value) == false &&
            value.toString().endsWith(terminacao) == true) {
          value++;
        }
      }
      tabelaFixa[key + '1'] = value;
      int nextValue = value + 10;
      while (validadorNumeroPrimo(nextValue) == false) {
        nextValue = nextValue + 10;
      }
      tabelaFixa[key + '2'] = nextValue;
    });

    return tabelaFixa;
  }

  List<int> formula1(Map<String, int> numerosFixos, int rangeB) {
    List<int> primosECompostosPrimazes = [];
    List<int> removerNPrimos = [];
    int resultFunction = 0;

    numerosFixos.forEach((key, value) {
      for (int i = 0; resultFunction < rangeB; i++) {
        resultFunction = (30 * i) + value;
        if (resultFunction < rangeB) {
          primosECompostosPrimazes.add(resultFunction);
        }
      }
      resultFunction = 0;
    });

    removerNPrimos.forEach((element) {
      primosECompostosPrimazes.remove(element);
    });

    return primosECompostosPrimazes;
  }
}
