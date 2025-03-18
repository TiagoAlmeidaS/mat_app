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
  bool _isCopyVisible = true; // Variável de controle para o botão

  @override
  void initState() {
    super.initState();
    _loadPage(page: currentPage);
    _scrollController.addListener(_handleScroll); // Chama o método refatorado
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      // Verifica se chegou próximo do fim para esconder o botão
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 50) {
        if (_isCopyVisible) {
          setState(() {
            _isCopyVisible = false;
          });
        }
      } else {
        if (!_isCopyVisible) {
          setState(() {
            _isCopyVisible = true;
          });
        }
      }
      // Também pode incluir a lógica de carregar nova página se estiver próximo do fim
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          currentPage < totalPages) {
        _loadPage(page: currentPage + 1);
      }
    }
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
        pageSize: 500,
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
      // Se o número de itens for menor que 29 e houver mais páginas, busca a próxima
      if (allPrimes.length < 29 && currentPage < totalPages) {
        _loadPage(page: currentPage + 1);
      }
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
      // O botão só será exibido se ainda não estiver na última página.
      floatingActionButton: _isCopyVisible
          ? AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _isCopyVisible ? 1.0 : 0.0,
              child: FloatingActionButton(
                onPressed: () {
                  final primesText = allPrimes.join(", ");
                  Clipboard.setData(ClipboardData(text: primesText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Números copiados para o Clipboard!")),
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
