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
        7,
        11,
        13,
        17,
        19,
        29,
        31,
        33,
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
        89,
        93,
        97
      ]);
    });

    test('validate the number is prime', () async {
      final isPrimed = service.validadorNumeroPrimo(53);

      expect(isPrimed, true);
    });

    test('listPrimesNumbers should return correct prime numbers that containt 53', () async {
      final start = 1;
      final end = 60;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
    });

    test('listPrimesNumbers should return correct prime numbers that containt 53 range to 1 at 50', () async {
      final start = 10;
      final end = 60;

      final result = await service.listPrimesNumbers(start, end);

      expect(result.contains(53), isTrue);
    });
  });
}
