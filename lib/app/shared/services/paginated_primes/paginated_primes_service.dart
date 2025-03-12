import 'dart:math';
import 'package:mat_app/app/shared/services/paginated_primes/paginated_primes_result.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class PaginatedPrimesService {
  final PrimesNumberService _service = PrimesNumberService();

  Future<PaginatedPrimesResult> getPrimesPage({
    required int start, 
    required int end, 
    required int page, 
    int pageSize = 100000,
  }) async {
    if (start > end) {
      throw Exception("Intervalo inválido, start deve ser menor ou igual a end.");
    }
    // Calcula a quantidade total de números e de páginas.
    final totalNumbers = end - start + 1;
    final totalPages = (totalNumbers / pageSize).ceil();

    print("Total de números: $totalNumbers, total de páginas: $totalPages");

    // Define o subintervalo correspondente à página atual.
    final pageStart = start + (page - 1) * pageSize;

  
    final pageEnd = min(pageStart + pageSize - 1, end);
    print("Página $page: [$pageStart, $pageEnd]");


    // Processa o subintervalo utilizando o serviço atual.
    final primes = await _service.listPrimesNumbers(pageStart, pageEnd);

    return PaginatedPrimesResult(
      primes: primes,
      currentPage: page,
      totalPages: totalPages,
    );
  }
}
