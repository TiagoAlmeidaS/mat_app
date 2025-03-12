import 'package:flutter_test/flutter_test.dart';
import 'package:mat_app/app/shared/services/paginated_primes/paginated_primes_service.dart';

void main() {
  late PaginatedPrimesService paginatedService;

  setUp(() {
    paginatedService = PaginatedPrimesService();
  });

  group('PaginatedPrimesService Tests', () {
    test('Throws exception for invalid range', () async {
      expect(
        () async => await paginatedService.getPrimesPage(start: 100, end: 50, page: 1),
        throwsException,
      );
    });

    test('Returns correct totalPages and primes for page 1', () async {
      // Usando um range pequeno e pageSize customizado para testar a paginação
      final start = 1;
      final end = 50; // totalNumbers = 50
      final pageSize = 20; // totalPages = ceil(50/20) = 3

      final result = await paginatedService.getPrimesPage(
        start: start,
        end: end,
        page: 1,
        pageSize: pageSize,
      );

      expect(result.currentPage, 1);
      expect(result.totalPages, 3);

      // O método utiliza PrimesNumberService.numerosPrimos
      // Para o subintervalo [1,20], espera que os primos retornados sejam:
      // Após remoção de [1,2,3,5] e considerando o validador, espera-se [7, 11, 13, 17, 19]
      expect(result.primes, equals([7, 11, 13, 17, 19]));
    });

    test('Returns correct primes for page 2', () async {
      // Para o mesmo range [1,50] com pageSize=20, page 2 cobre [21,40]
      final start = 1;
      final end = 50;
      final pageSize = 20;

      final result = await paginatedService.getPrimesPage(
        start: start,
        end: end,
        page: 2,
        pageSize: pageSize,
      );

      expect(result.currentPage, 2);
      expect(result.totalPages, 3);

      // Para o intervalo [21,40], os números primos válidos (desconsiderando 1,2,3,5) são:
      // [23, 29, 31, 37]
      expect(result.primes, equals([23, 29, 31, 37]));
    });

    test('Returns correct primes for last page', () async {
      // Para o range [1,50] com pageSize=20, a página 3 cobre [41,50]
      final start = 1;
      final end = 50;
      final pageSize = 20;

      final result = await paginatedService.getPrimesPage(
        start: start,
        end: end,
        page: 3,
        pageSize: pageSize,
      );

      expect(result.currentPage, 3);
      expect(result.totalPages, 3);

      // Para o intervalo [41,50], os primos esperados são [41, 43, 47]
      // Porém, se o método remove os números fixos (1,2,3,5), 41, 43, 47 devem permanecer.
      expect(result.primes, equals([41, 43, 47]));
    });

    test(
      'Deve retornar números corretos dentro do intervalo (72000000, 72001000)',
      () async {
        final start = 72000000;
        final end = 72001000;

        // Supondo que os cálculos desse intervalo caibam em uma única página
        final result = await paginatedService.getPrimesPage(
          start: start,
          end: end,
          page: 1,
        );

        print(result.primes);

        // Verifica se determinados números não estão na lista
        expect(result.primes.contains(72000001), isFalse);
        expect(result.primes.contains(72000011), isFalse);
      },
      timeout: Timeout(Duration(minutes: 5)),
    );
  });
}
