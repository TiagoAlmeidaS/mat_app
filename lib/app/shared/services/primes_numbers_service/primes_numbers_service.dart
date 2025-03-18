import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mat_app/app/shared/services/fixed_number_generator.dart';
import 'package:mat_app/app/shared/services/number_validator.dart';

class PrimesNumberService {

  NumberValidator validator = NumberValidator();
  FixedNumberGenerator? fixedNumberGenerator;

  PrimesNumberService() {
    fixedNumberGenerator = FixedNumberGenerator(validator);
  }

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
    Set<int> primes = {};
    int chunkSize = 1000; // Processa em blocos de 1000 números

    print("Estou sendo calculado aqui");

    // numbers prime exception -> 1, 2, 3, 5
    List<int> elementsExceptions = [1, 2, 3, 5];

    for (int i = start; i <= end; i += chunkSize) {
      final chunkStart = i;
      final chunkEnd = (i + chunkSize - 1).clamp(chunkStart, end);

      // Processa cada bloco
      primes.addAll(processChunk(chunkStart, chunkEnd));

      primes.removeAll(elementsExceptions);

      // Aguarda um frame para evitar travamento
      await Future.delayed(Duration(milliseconds: 1));
    }

    return primes.toList();
  }

  // Método auxiliar para processar um bloco de números
  List<int> processChunk(int start, int end) {
    // numbers prime exception -> 1, 2, 3, 5
    List<int> elementsExceptions = [1, 2, 3, 5];
    Set<int> primes = {};
    for (int i = start; i <= end; i++) {
      if (validadorNumeroPrimo(i)) primes.add(i);
    }

    primes.removeAll(elementsExceptions);
    return primes.toList();
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
      print("Primes: $primes");
    } catch (e) {
      print('Erro ao calcular números primos: $e. Tentando novamente.');
      if(end < 50){
        primes = processChunk(start, end);
      } else {
        primes = await numerosPrimos(start, end);
      }
    }

    // Envia os resultados de volta para o main isolate
    sendPort.send(primes);
  }

  // Versão atualizada do método que calcula os números primos com tratamento para grandes intervalos.
  Future<List<int>> numerosPrimos(int rangeA, int rangeB) async {
    // Defina um limite menor para processamentos seguros no dispositivo
    final maxRange = 10000000; // exemplo de limite para evitar falhas de memória
    if ((rangeB - rangeA) > maxRange) {
      throw Exception("Intervalo muito grande. Por favor, reduza o range para evitar falhas de memória.");
    }
    
    // Se o range é elevado, processa em chunks para evitar loading excessivo
    return await compute(_calculateNumerosPrimos, {'rangeA': rangeA, 'rangeB': rangeB});
  }
  
  // Novo método usando processamento em chunk para cálculos sem sobrecarregar a memória.
  List<int> _calculateNumerosPrimosChunked(Map<String, int> params) {
    int rangeA = params['rangeA']!;
    int rangeB = params['rangeB']!;
    // Divida o range em blocos menores (por exemplo, 100K números por bloco)
    int chunkSize = 100000; 
    Set<int> resultados = {};
    
    for (int chunkStart = rangeA; chunkStart <= rangeB; chunkStart += chunkSize) {
      int chunkEnd = (chunkStart + chunkSize - 1).clamp(chunkStart, rangeB);
      
      // Utilize o algoritmo atual para o bloco
      final partial = _calculateNumerosPrimos({'rangeA': chunkStart, 'rangeB': chunkEnd});
      resultados.addAll(partial);
    }
    
    List<int> listaOrdenada = resultados.toList()..sort();
    return listaOrdenada;
  }

  List<int> _calculateNumerosPrimos(Map<String, int> params) {
    print("Iniciando fórmula...");
    int rangeA = params['rangeA']!;
    int rangeB = params['rangeB']!;
    Map<String, int> fixos = {};
    List<int> primosBasicos = [];
    Set<int> formulaUm = {};
    List<int> excluirNaoNumeroPrimo = [1,2,3,5];

    primosBasicos = numerosPrimosBasicos(rangeB);
    print("Primos básicos: $primosBasicos");
    fixos = fixedNumberGenerator?.generateFixedNumbers(rangeA, rangeB) ?? {};
    print("Fixos: $fixos");
    if(rangeB > 1000000){
      formulaUm = formula1v2(fixos, rangeB).toSet();
    }else{
      formulaUm = formula1v2(fixos, rangeB).toSet();
    }
    print("Fórmula 1 v2: $formulaUm");

    for (int element1 in primosBasicos) {
      for (int element2 in formulaUm) {
        if (element2 % element1 == 0 && element2 > element1) {
          excluirNaoNumeroPrimo.add(element2);
        }
      }
    }

    print("Excluir não primos: $excluirNaoNumeroPrimo");

    formulaUm.removeAll(excluirNaoNumeroPrimo);

    print("Fórmula 1 final: $formulaUm");

    return formulaUm.toList()..sort((a, b) => a.compareTo(b));
  }

  bool validadorNumeroPrimo(int numero) {
    bool ret = false;

    if (numero == 2) {
      ret = true;
      return ret;
    }

    if (numero == 3) {
      ret = true;
      return ret;
    }

    if (numero == 5) {
      ret = true;
      return ret;
    }

    if (numero == 7) {
      ret = true;
      return ret;
    }

    if (numero == 1) {
      ret = false;
      return ret;
    }

    if (numero % 5 == 0) {
      ret = false;
      return ret;
    }

    if (numero % 3 == 0) {
      ret = false;
      return ret;
    }

    if (numero % 2 == 0) {
      ret = false;
      return ret;
    }

    if (!numero.toString().endsWith('1') ||
        !numero.toString().endsWith('3') ||
        !numero.toString().endsWith('7') ||
        !numero.toString().endsWith('9')) {
      ret = true;
      return ret;
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
      return ret;
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

      //TODO: Necessário que meu value ele seja maior que sete. 
      while (value.toString().endsWith(terminacao) == false || value == 1) {
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

    print("Tabela fixa: $tabelaFixa");
    return tabelaFixa;
  }

  List<int> formula1(Map<String, int> numerosFixos, int rangeB) {
    List<int> primosECompostosPrimazes = [];
    Set<int> removerNPrimos = {}; // Usar Set para evitar duplicatas
    int resultFunction;

    numerosFixos.forEach((key, value) {
      // Gera os números da fórmula 1 para cada valor t
      for (int n = 0; (resultFunction = 30 * n + value) <= rangeB; n++) {
        if(validadorNumeroPrimo(resultFunction)){
          primosECompostosPrimazes.add(resultFunction);
        }
      }
    });

    // Identifica e remove os múltiplos dos primos básicos
    for (int i = 2; i <= sqrt(rangeB).toInt(); i++) {
      if (validadorNumeroPrimo(i)) {
        for (int j = i * i; j <= rangeB; j += i) {
          removerNPrimos.add(j);
        }
      }
    }

    // Remove os números compostos
    primosECompostosPrimazes.removeWhere((number) => removerNPrimos.contains(number));

    return primosECompostosPrimazes..sort();
  }

  // Novo método formula1v2 com otimizações de desempenho.
  List<int> formula1v2(Map<String, int> numerosFixos, int rangeB) {
    Set<int> resultados = {}; // Usar Set para evitar duplicatas
    
    // Para cada valor fixo, calcula o n máximo possível e itera até lá.
    numerosFixos.forEach((key, value) {
      int maxN = ((rangeB - value) / 30).floor();
      for (int n = 0; n <= maxN; n++) {
        int resultFunction = 30 * n + value;
        if (validadorNumeroPrimo(resultFunction)) {
          resultados.add(resultFunction);
        }
      }
    });
    
    // Identifica e remove os múltiplos dos primos básicos utilizando o método de crivo simples.
    int sqrtRangeB = sqrt(rangeB).toInt();
    Set<int> removerNPrimos = {};
    for (int i = 2; i <= sqrtRangeB; i++) {
      if (validadorNumeroPrimo(i)) {
        for (int j = i * i; j <= rangeB; j += i) {
          removerNPrimos.add(j);
        }
      }
    }
    
    resultados.removeAll(removerNPrimos);
    
    List<int> listaOrdenada = resultados.toList()
      ..sort((a, b) => a.compareTo(b));
    
    return listaOrdenada;
  }
}
