import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/services.dart'; // Import para Clipboard
import 'package:mat_app/app/shared/mat_theme/color_theme/color_theme.dart';

import '../../../../shared/services/paginated_primes/paginated_primes_service.dart';

class ViewNumbersPage extends StatefulWidget {
  ViewNumbersPage({Key? key, required this.startNumber, required this.endNumber, }) : super(key: key);

  final int startNumber;
  final int endNumber;

  @override
  State<ViewNumbersPage> createState() => _ViewNumbersPageState();
}

class _ViewNumbersPageState extends State<ViewNumbersPage> {
  final PaginatedPrimesService _paginatedService = PaginatedPrimesService();
  final ScrollController _scrollController = ScrollController();

  List<int> allPrimes = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;
  bool isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage(page: currentPage);
    _scrollController.addListener(() {
      // Se estiver próximo do final e tiver mais páginas
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore && currentPage < totalPages) {
          _loadPage(page: currentPage + 1);
        }
      }
    });
  }

  Future<void> _loadPage({required int page}) async {
    setState(() {
      isLoadingMore = true;
    });
    try {
      final result = await _paginatedService.getPrimesPage(
        start: widget.startNumber,
        end: widget.endNumber,
        page: page,
        pageSize: 500
      );
      // Atualiza estado com os novos dados
      setState(() {
        if (page == 1) {
          allPrimes = result.primes;
        } else {
          allPrimes.addAll(result.primes);
        }
        currentPage = result.currentPage;
        totalPages = result.totalPages;
      });
    } catch (e) {
      print("Erro ao carregar página $page: $e");
    } finally {
      setState(() {
        isLoadingMore = false;
        isInitialLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onTap: () => Modular.to.pop(),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Primoes Encontrados: ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 15,),
                  Text(
                    "Página $currentPage/$totalPages",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverGrid.count(
          crossAxisCount: 4,
          children: allPrimes
              .map((e) => Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Modular.get<ColorTheme>().secondaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "$e",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        // Exibe indicador ao final se estiver carregando mais
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Modular.get<ColorTheme>().primaryColor,
      body: SafeArea(
        child: isInitialLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Converte a lista de primos em uma string separada por vírgulas.
          final primesText = allPrimes.join(", ");
          Clipboard.setData(ClipboardData(text: primesText));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Números copiados para o Clipboard!")),
          );
        },
        tooltip: "Copiar para Clipboard",
        child: const Icon(Icons.copy),
      ),
    );
  }
}
