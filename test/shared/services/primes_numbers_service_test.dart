import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

void main() {
  late PrimesNumberService service;

  setUp(() {
    service = PrimesNumberService();
  });

  group('PrimesNumberService Tests', () {
    test('Validating validadorNumeroPrimo with prime numbers', () {
      expect(service.validadorNumeroPrimo(2), true);
      expect(service.validadorNumeroPrimo(3), true);
      expect(service.validadorNumeroPrimo(5), true);
      expect(service.validadorNumeroPrimo(7), true);
    });

    test('Validating validadorNumeroPrimo with non-prime numbers', () {
      expect(service.validadorNumeroPrimo(1), false);
      expect(service.validadorNumeroPrimo(4), false);
      expect(service.validadorNumeroPrimo(6), false);
      expect(service.validadorNumeroPrimo(8), false);
      expect(service.validadorNumeroPrimo(9), false);
    });

    test('listPrimesNumbers for small range', () async {
      final primes = await service.listPrimesNumbers(1, 10);
      expect(primes, [7]);
    });

    test('listPrimesNumbers for large range', () async {
      final primes = await service.listPrimesNumbers(10, 20);
      expect(primes, [11, 13, 17, 19]);
    });

    test('listPrimesNumbers for invalid range', () async {
      try {
        await service.listPrimesNumbers(20, 10);
        fail("Should have thrown an error for invalid range.");
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('_processChunk processes numbers correctly', () {
      final primes = service.processChunk(1, 10);
      expect(primes, [7]);
    });

    test('listPrimesNumbersV2 handles isolates properly', () async {
      final primes = await service.listPrimesNumbersV2(1, 10);
      expect(primes, [7]);
    });

    test('listPrimesNumbersV2 handles range 10 to 50', () async {
      final primes = await service.listPrimesNumbersV2(10, 50);
      expect(primes, [11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]);
    });

    test('listPrimesNumbersV2 handles range 1 to 100', () async {
      final primes = await service.listPrimesNumbersV2(1, 100);
      expect(primes, [
        7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
      ]);
    });

    test('validate the number is prime', () async {
      final isPrimed = service.validadorNumeroPrimo(53);

      expect(isPrimed, true);
    });

    test(
        'listPrimesNumbers should return correct prime numbers that containt 53',
        () async {
      final start = 1;
      final end = 60;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
    });

    test(
        'listPrimesNumbers should return correct prime numbers that containt 53 range to 1 at 50',
        () async {
      final start = 10;
      final end = 60;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
    });

    test('Compare the numbers range  to 500', () async {
      final start = 1;
      final end = 500;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);

      expect(result, [
        7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211,  223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499]);
    });

    test('Compare the numbers range  to 100', () async {
      final start = 1;
      final end = 100;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);

      expect(result, [7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]);
    });

    test('Compare the numbers range 9  to 10000', () async {
      final start = 9;
      final end = 10000;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(9137), isTrue);
      expect(result.contains(9173), isTrue);
      expect(result.contains(9203), isTrue);
      expect(result.contains(9227), isTrue);
      expect(result.contains(9257), isTrue);
      expect(result.contains(9293), isTrue);
      expect(result.contains(9323), isTrue);
      expect(result.contains(9377), isTrue);
      expect(result.contains(9413), isTrue);
      expect(result.contains(9437), isTrue);
      expect(result.contains(9467), isTrue);
      expect(result.contains(9473), isTrue);
      expect(result.contains(9497), isTrue);
      expect(result.contains(9533), isTrue);
      expect(result.contains(9587), isTrue);
      expect(result.contains(9587), isTrue);
      expect(result.contains(9677), isTrue);
      expect(result.contains(9743), isTrue);
      expect(result.contains(9767), isTrue);
      expect(result.contains(9803), isTrue);
      expect(result.contains(9833), isTrue);
      expect(result.contains(9857), isTrue);
      expect(result.contains(9887), isTrue);
      expect(result.contains(9923), isTrue);
      expect(result.contains(9923), isTrue);
    });

    test('Compare the numbers range 9000 to 10000', () async {
      final start = 9000;
      final end = 10000;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(9137), isTrue);
      expect(result.contains(9173), isTrue);
      expect(result.contains(9203), isTrue);
      expect(result.contains(9227), isTrue);
      expect(result.contains(9257), isTrue);
      expect(result.contains(9293), isTrue);
      expect(result.contains(9323), isTrue);
      expect(result.contains(9377), isTrue);
      expect(result.contains(9413), isTrue);
      expect(result.contains(9437), isTrue);
      expect(result.contains(9467), isTrue);
      expect(result.contains(9473), isTrue);
      expect(result.contains(9497), isTrue);
      expect(result.contains(9533), isTrue);
      expect(result.contains(9587), isTrue);
      expect(result.contains(9587), isTrue);
      expect(result.contains(9677), isTrue);
      expect(result.contains(9743), isTrue);
      expect(result.contains(9767), isTrue);
      expect(result.contains(9803), isTrue);
      expect(result.contains(9833), isTrue);
      expect(result.contains(9857), isTrue);
      expect(result.contains(9887), isTrue);
      expect(result.contains(9923), isTrue);
      expect(result.contains(9923), isTrue);
    });

    test('Compare the numbers range 8  to 8000', () async {
      final start = 8;
      final end = 9000;

      final result = await service.listPrimesNumbers(start, end);

      
      expect(result.contains(8059), isTrue);
      expect(result.contains(8089), isTrue);
    });
  });

  group('Formula1 Tests', () {
    late PrimesNumberService service;

    setUp(() {
      service = PrimesNumberService();
    });

    test('Deve retornar números corretos dentro do intervalo (7, 500)', () {
      // Valores fixos fornecidos pela fórmula na documentação
      final numerosFixos = {
        't11': 11,
        't12': 31,
        't31': 13,
        't32': 23,
        't71': 7,
        't72': 17,
        't91': 19,
        't92': 29
      };

      final rangeB = 500;
      final expectedOutput = [
        7,
        11,
        13,
        17,
        19,
        23,
        29,
        31,
        37,
        41,
        43,
        47,
        53,
        59,
        61,
        67,
        71,
        73,
        79,
        83,
        89,
        97,
        101,
        103,
        107,
        109,
        113,
        127,
        131,
        137,
        139,
        149,
        151,
        157,
        163,
        167,
        173,
        179,
        181,
        191,
        193,
        197,
        199,
        211,
        223,
        227,
        229,
        233,
        239,
        241,
        251,
        257,
        263,
        269,
        271,
        277,
        281,
        283,
        293,
        307,
        311,
        313,
        317,
        331,
        337,
        347,
        349,
        353,
        359,
        367,
        373,
        379,
        383,
        389,
        397,
        401,
        409,
        419,
        421,
        431,
        433,
        439,
        443,
        449,
        457,
        461,
        463,
        467,
        479,
        487,
        491,
        499
      ];

      final result = service.formula1(numerosFixos, rangeB);

      expect(result, equals(expectedOutput));
    });

    test('Deve retornar números corretos dentro do intervalo (10, 60)', () {
      // Valores fixos fornecidos pela fórmula na documentação
      final numerosFixos = {
        't11': 11,
        't12': 31,
        't31': 13,
        't32': 23,
        't71': 17,
        't72': 37,
        't91': 19,
        't92': 29
      };

      final rangeB = 60;
      final expectedOutput = [
        11,
        13,
        17,
        19,
        23,
        29,
        31,
        37,
        41,
        43,
        47,
        53,
        59
      ];

      final result = service.formula1(numerosFixos, rangeB);

      expect(result, equals(expectedOutput));
    });

    test(
        'Não deve incluir múltiplos de primos básicos dentro do intervalo (7, 100)',
        () {
      // Valores fixos fornecidos pela fórmula na documentação
      final numerosFixos = {
        't11': 11,
        't12': 31,
        't31': 13,
        't32': 23,
        't71': 7,
        't72': 17,
        't91': 19,
        't92': 29
      };

      final rangeB = 100;
      final unexpectedNumbers = [
        91,
        77,
        49
      ]; // Números compostos que não devem aparecer

      final result = service.formula1(numerosFixos, rangeB);

      for (final number in unexpectedNumbers) {
        expect(result, isNot(contains(number)));
      }
    });

    test('Deve retornar números corretos dentro do intervalo (72000000, 72001000)', () async {
      final start = 72000000;
      final end = 72001000;

      final result = await service.listPrimesNumbers(start, end);

      print(result);

      // Verifica se 72000001 não está na lista
      expect(result.contains(72000001), isFalse);
      expect(result.contains(72000011), isFalse);
    }, timeout: Timeout(Duration(minutes: 5)));
  });

  group('Formula1v2 Performance Tests', () {
    late PrimesNumberService service;
    final numerosFixos = {
      't11': 11,
      't12': 31,
      't31': 13,
      't32': 23,
      't71': 7,
      't72': 17,
      't91': 19,
      't92': 29
    };

    // Utilize um range grande para medir a performance.
    final int rangeB = 10000;

    setUp(() {
      service = PrimesNumberService();
    });

    test('formula1 vs formula1v2 retornam resultados iguais', () {
      final result1 = service.formula1(numerosFixos, rangeB);
      final result2 = service.formula1v2(numerosFixos, rangeB);

      expect(result1, equals(result2));
    });

    test('formula1v2 deve ser mais rápida que formula1', () {
      final sw1 = Stopwatch()..start();
      service.formula1(numerosFixos, rangeB);
      sw1.stop();

      final sw2 = Stopwatch()..start();
      service.formula1v2(numerosFixos, rangeB);
      sw2.stop();

      print('Tempo formula1: ${sw1.elapsedMilliseconds} ms');
      print('Tempo formula1v2: ${sw2.elapsedMilliseconds} ms');

      // Ajuste o critério conforme necessário (ex: esperar que formula1v2 seja pelo menos 10% mais rápida)
      expect(sw2.elapsedMilliseconds, lessThan(sw1.elapsedMilliseconds));
    });
  });
}
