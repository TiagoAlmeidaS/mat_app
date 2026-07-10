class PrimeCalculationRequest {
  const PrimeCalculationRequest({
    required this.start,
    required this.end,
  });

  final int start;
  final int end;

  int get intervalLength => (end - start) + 1;

  bool get isValid => start >= 0 && end >= 0 && start <= end;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PrimeCalculationRequest &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}
