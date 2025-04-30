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
  
  // Novo método para logar o tempo de execução de funções assíncronas.
  Future<T> _logExecutionTimeAsync<T>(String methodName, Future<T> Function() function) async {
    final start = DateTime.now();
    T result = await function();
    final end = DateTime.now();
    print("[$methodName] executado em ${end.difference(start).inMilliseconds}ms");
    return result;
  }
  
  // Novo método para logar o tempo de execução de funções síncronas.
  T _logExecutionTimeSync<T>(String methodName, T Function() function) {
    final start = DateTime.now();
    T result = function();
    final end = DateTime.now();
    print("[$methodName] executado em ${end.difference(start).inMilliseconds}ms");
    return result;
  }

  // Método principal para obter números primos, adaptando por plataforma
  Future<List<int>> listPrimesNumbers(int start, int end) async {
    return await _logExecutionTimeAsync("listPrimesNumbers", () async {
      if (kIsWeb) {
        // Comportamento para Web
        return await _listPrimesNumbersWeb(start, end);
      } else {
        // Comportamento para Mobile/Desktop
        return await listPrimesNumbersV2(start, end);
      }
    });
  }

  // Implementação para Web (chunking)
  Future<List<int>> _listPrimesNumbersWeb(int start, int end) async {
    return await _logExecutionTimeAsync("_listPrimesNumbersWeb", () async {
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
    });
  }

  // Método auxiliar para processar um bloco de números
  List<int> processChunk(int start, int end) {
    return _logExecutionTimeSync("processChunk", () {
      // numbers prime exception -> 1, 2, 3, 5
      List<int> elementsExceptions = [1, 2, 3, 5];
      Set<int> primes = {};
      for (int i = start; i <= end; i++) {
        if (validadorNumeroPrimo(i)) primes.add(i);
      }
  
      primes.removeAll(elementsExceptions);
      return primes.toList();
    });
  }

  // Implementação para Mobile/Desktop usando Isolates
  Future<List<int>> listPrimesNumbersV2(int start, int end) async {
    return await _logExecutionTimeAsync("listPrimesNumbersV2", () async {
      final ReceivePort receivePort = ReceivePort();
  
      // Spawna um isolate
      await Isolate.spawn(_calculatePrimesInIsolate, [receivePort.sendPort, start, end]);
  
      // Recebe os dados do isolate
      return await receivePort.first;
    });
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
      if (end < 50) {
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
    return await _logExecutionTimeAsync("numerosPrimos", () async {
      // Defina um limite menor para processamentos seguros no dispositivo
      final maxRange = 10000000; // exemplo de limite para evitar falhas de memória
      if ((rangeB - rangeA) > maxRange) {
        throw Exception("Intervalo muito grande. Por favor, reduza o range para evitar falhas de memória.");
      }
      
      // Se o range é elevado, processa em chunks para evitar loading excessivo
      return await compute(_calculateNumerosPrimos, {'rangeA': rangeA, 'rangeB': rangeB});
    });
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

    primosBasicos = _logExecutionTimeSync("numerosPrimosBasicos", () {
      return numerosPrimosBasicos(rangeB);
    });
    
    print("Primos básicos: $primosBasicos");
    fixos = fixedNumberGenerator?.generateFixedNumbers(rangeA, rangeB) ?? {};
    print("Fixos: $fixos");
    if(rangeB > 1000000){
      _logExecutionTimeSync("formula1v2", () {
        formulaUm = formula1v2(fixos, rangeB).toSet();
      });
    }else{
      _logExecutionTimeSync("formula1", () {
        formulaUm = formula1(fixos, rangeB).toSet();
      });
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
    // Verificação rápida de casos especiais
    if (numero == 1) return false;
    if (numero == 2 || numero == 3 || numero == 5 || numero == 7) return true;
    
    // Verificação de múltiplos de 2, 3 e 5
    if (numero % 2 == 0 || numero % 3 == 0 || numero % 5 == 0) return false;
    
    // Verificação de terminação (deve terminar em 1, 3, 7 ou 9)
    final ultimoDigito = numero % 10;
    if (ultimoDigito != 1 && ultimoDigito != 3 && ultimoDigito != 7 && ultimoDigito != 9) {
      return false;
    }
    
    // Verificação de soma dos dígitos (múltiplo de 3)
    int soma = 0;
    int n = numero;
    while (n > 0) {
      soma += n % 10;
      n ~/= 10;
    }
    if (soma % 3 == 0) return false;
    
    return true;
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
    final Map<String, int> tabelaFixa = {};
    final List<int> terminacoes = [1, 3, 7, 9];
    
    for (final terminacao in terminacoes) {
      int value = rangeA;
      
      // Encontra o primeiro número terminado em 'terminacao' maior que rangeA
      while (value % 10 != terminacao || value == 1) {
        value++;
      }
      
      // Verifica se é primo
      if (!validadorNumeroPrimo(value)) {
        value += 10;
        while (!validadorNumeroPrimo(value)) {
          value += 10;
        }
      }
      
      tabelaFixa['t${terminacao}1'] = value;
      
      // Encontra o próximo número terminado em 'terminacao' que é primo
      int nextValue = value + 10;
      while (!validadorNumeroPrimo(nextValue)) {
        nextValue += 10;
      }
      tabelaFixa['t${terminacao}2'] = nextValue;
    }
    
    return tabelaFixa;
  }

  List<int> formula1(Map<String, int> numerosFixos, int rangeB) {
    final Set<int> resultados = {};
    
    for (final entry in numerosFixos.entries) {
      final value = entry.value;
      final maxN = ((rangeB - value) / 30).floor();
      
      for (int n = 0; n <= maxN; n++) {
        final resultFunction = 30 * n + value;
        if (resultFunction <= rangeB && validadorNumeroPrimo(resultFunction)) {
          resultados.add(resultFunction);
        }
      }
    }
    
    return resultados.toList()..sort();
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

  List<int> formula2(List<int> primosBasicos, int rangeB) {
    final Set<int> compostosPrimazes = {};
    
    for (final pb in primosBasicos) {
      final razao = 30 * pb;
      final maxN = ((rangeB - pb) / razao).floor();
      
      // Gera compostos primazes para cada terminação
      for (int n = 0; n <= maxN; n++) {
        final term1 = pb * (10 * n + 1);
        final term3 = pb * (10 * n + 3);
        final term7 = pb * (10 * n + 7);
        final term9 = pb * (10 * n + 9);
        
        if (term1 <= rangeB) compostosPrimazes.add(term1);
        if (term3 <= rangeB) compostosPrimazes.add(term3);
        if (term7 <= rangeB) compostosPrimazes.add(term7);
        if (term9 <= rangeB) compostosPrimazes.add(term9);
      }
    }
    
    return compostosPrimazes.toList()..sort();
  }
}
