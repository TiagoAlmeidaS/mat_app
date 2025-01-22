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
