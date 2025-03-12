class PaginatedPrimesResult {
  final List<int> primes;
  final int currentPage;
  final int totalPages;

  PaginatedPrimesResult({
    required this.primes,
    required this.currentPage,
    required this.totalPages,
  });
}