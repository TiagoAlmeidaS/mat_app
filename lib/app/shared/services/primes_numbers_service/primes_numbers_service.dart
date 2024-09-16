import 'dart:math';
import 'package:flutter/foundation.dart';

class PrimesNumberService{

  List<int> listPrimesNumbers(int start, int end) {

    List<int> rangePrimos = [];

    if (start >= 0 && end <= 20) {
      return [5, 7, 11, 13, 17, 19].where((prime) => prime >= start && prime <= end).toList();
    }

    var numerocalculados = numerosPrimos(start, end);

    rangePrimos.addAll(numerocalculados);

    for (var number in rangePrimos) {
      if (!validadorNumeroPrimo(number)) {
        rangePrimos.remove(number);
      }
    }

    if (kDebugMode) {
      print(rangePrimos);
    }
    return rangePrimos;
  }


  void comparadorDosPrimos(int base, List<int> numerosPrimos) {
    List<int> numerosSomados = [];

    numerosPrimos.forEach((element) {
      numerosSomados.add(element + base);
    });

    print(numerosSomados);
  }

// Verificar se a divisão de outro primo -> Par
//

  List<int> numerosPrimos(int rangeA, int rangeB) {
    Map<String, int> fixos = {};
    List<int> primosBasicos = [];
    List<int> formulaUm = [];
    List<int> excluirNaoNumeroPrimo = [];

    primosBasicos = numerosPrimosBasicos(rangeB);
    fixos = numerosFixos(rangeA: rangeA, rangeB: rangeB);
    formulaUm = formula1(fixos, rangeB);

    primosBasicos.forEach((element1) {
      formulaUm.forEach((element2) {
        if (element2 % element1 == 0 && element2 > element1) {
          excluirNaoNumeroPrimo.add(element2);
        }
      });
    });

    excluirNaoNumeroPrimo.forEach((element) {
      formulaUm.remove(element);
    });

    var teste = formulaUm..sort((a, b) => a.compareTo(b));

    print("${teste}");

    return formulaUm;
  }

  bool validadorNumeroPrimo(int numero) {
    bool ret = false;

    //Valida se número é divisível por 3
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

    //Validador Número primo
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
    //Verifica se é número primo
    while (validadorNumeroPrimo(numeroBase) == false) {
      numeroBase--;
    }

    for (int numeroAux = numeroBase; numeroAux >= 7; numeroAux--) {
      if (validadorNumeroPrimo(numeroAux) == true) {
        numerosAuxBasicos.add(numeroAux);
      }
    }

    numerosBasicos = numerosAuxBasicos;

    //Necessário para verificar se um "Primo" é dívisível pelo outro
    numerosAuxBasicos.forEach((e1) {
      numerosAuxBasicos.forEach((e2) {
        if (e1 % e2 == 0 && numerosBasicos.contains(e1) && e1 > e2) {
          removeNPrimos.add(e1);
        }
      });
    });

    //Adicioandos a uma lista para poder remover, pois o programa não permite
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

  Map<String, int> multiplos(
      {required List<int> primosBasicos, required int rangeA}) {
    Map<String, int> multPb = {};
    Map<String, Map<String, int>> nAux = {};

    Map<String, String> terminacoes = Map<String, String>();
    terminacoes['n1'] = '1';
    terminacoes['n3'] = '3';
    terminacoes['n7'] = '7';
    terminacoes['n9'] = '9';
    int numeroBasico = 0;

    primosBasicos.forEach((element) {
      print("primosBasicos: " + element.toString());
      Map<String, int> sequenciasNumeros = {};
      numeroBasico = (rangeA / element).round();
      terminacoes.forEach((key, terminacao) {
        while (validadorNumeroPrimo(numeroBasico) == false &&
            !numeroBasico.toString().endsWith(terminacao)) {
          numeroBasico++;
        }
        int nextValue = numeroBasico + 10;
        while (validadorNumeroPrimo(nextValue) == false) {
          nextValue = nextValue + 10;
        }

        sequenciasNumeros.addAll({key + '1': numeroBasico, key + '2': nextValue});

        numeroBasico++;
      });

      print(sequenciasNumeros);
      String elemento = element.toString();
      nAux.putIfAbsent(elemento, () => sequenciasNumeros);
    });
    print("end of primosBasicos");
    nAux.addAll({
      '19': {'n11': 11}
    });

    print("nAux: " + nAux.toString());
    return multPb;
  }

  List<int> multiploPrimos(Map<String, int> multiplos, int rangeB) {
    List<int> multiplosPrimos = [];

    return multiplosPrimos;
  }

}