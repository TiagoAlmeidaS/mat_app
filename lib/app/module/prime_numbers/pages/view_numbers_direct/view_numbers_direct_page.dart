import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/services.dart';
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';
import 'package:mat_app/app/shared/services/primes_numbers_service/primes_numbers_service.dart';

class ViewNumbersDirectPage extends StatefulWidget {
  ViewNumbersDirectPage({
    Key? key,
    required this.startNumber,
    required this.endNumber,
  }) : super(key: key);

  final int startNumber;
  final int endNumber;

  @override
  State<ViewNumbersDirectPage> createState() => _ViewNumbersDirectPageState();
}

class _ViewNumbersDirectPageState extends State<ViewNumbersDirectPage> {
  final PrimesNumberService _service = PrimesNumberService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isCopyVisible = true;
  List<int> _primes = [];

  @override
  void initState() {
    super.initState();
    _loadPrimes();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 50) {
        if (_isCopyVisible) {
          setState(() => _isCopyVisible = false);
        }
      } else {
        if (!_isCopyVisible) {
          setState(() => _isCopyVisible = true);
        }
      }
    }
  }

  Future<void> _loadPrimes() async {
    try {
      final primes = await _service.listPrimesNumbers(widget.startNumber, widget.endNumber);
      setState(() {
        _primes = primes;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar números primos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar números primos: $e")),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onTap: () => Modular.to.pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Números Primos Encontrados:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Total: ${_primes.length} números",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverGrid.count(
          crossAxisCount: 4,
          children: _primes.map((prime) => Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
              decoration: BoxDecoration(
                color: Modular.get<ColorTheme>().secondaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "$prime",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Modular.get<ColorTheme>().primaryColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildGrid(),
      ),
      floatingActionButton: _isCopyVisible
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isCopyVisible ? 1.0 : 0.0,
              child: FloatingActionButton(
                onPressed: () {
                  final primesText = _primes.join(", ");
                  Clipboard.setData(ClipboardData(text: primesText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Números copiados para o Clipboard!")),
                  );
                },
                tooltip: "Copiar para Clipboard",
                child: const Icon(Icons.copy),
              ),
            )
          : null,
    );
  }
} 