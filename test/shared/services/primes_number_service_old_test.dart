import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/prime_number_service_old.dart';

void main() {
  group('PrimesNumberServiceOld Tests', () {
    late PrimesNumberServiceOld service;

    setUp(() {
      service = PrimesNumberServiceOld();
    });

    test('listPrimesNumbers should return correct prime numbers that containt 53', () {
      final start = 1;
      final end = 100;

      final result = service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
    });

    test('listPrimesNumbers should return correct prime numbers that containt 53 with range 10 to 100', () {
      final start = 10;
      final end = 100;

      final result = service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
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

    test('validadorNumeroPrimo should correctly identify prime numbers', () {
      expect(service.validadorNumeroPrimo(2), isTrue);
      expect(service.validadorNumeroPrimo(3), isTrue);
      expect(service.validadorNumeroPrimo(17), isTrue);
      expect(service.validadorNumeroPrimo(4), isFalse);
      expect(service.validadorNumeroPrimo(9), isFalse);
    });

    test('numerosPrimos should return all primes in the range', () {
      final rangeA = 10;
      final rangeB = 20;
      final expectedPrimes = [11, 13, 17, 19];

      final result = service.numerosPrimos(rangeA, rangeB);

      expect(result, equals(expectedPrimes));
    });

    test('numerosPrimosBasicos should return basic primes', () {
      final rangeB = 50;
      final expectedPrimes = [7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];

      final result = service.numerosPrimosBasicos(rangeB);

      expect(result, equals(expectedPrimes));
    });

    test('numerosFixos should generate fixed numbers for given range', () {
      final rangeA = 10;
      final rangeB = 50;

      final result = service.numerosFixos(rangeA: rangeA, rangeB: rangeB);

      expect(result.keys.length, greaterThan(0)); // Verifica se chaves foram geradas
    });

    test('formula1 should generate correct sequence of numbers', () {
      final numerosFixos = {'t11': 11, 't12': 31};
      final rangeB = 50;
      final expectedSequence = [11, 31, 41];

      final result = service.formula1(numerosFixos, rangeB);

      expect(result, containsAll(expectedSequence));
    });

    test('comparadorDosPrimos should print summed primes', () {
      final base = 5;
      final primes = [2, 3, 7];

      service.comparadorDosPrimos(base, primes);

      // Aqui você pode verificar o console ou modificar a função para retornar a lista somada em vez de apenas imprimir
    });
  });
}
