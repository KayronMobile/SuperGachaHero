import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../domain/agente.dart';
import '../../data/repository/agente_repository.dart';
import '../widgets/agentes_card.dart';

class AgentesPage extends StatefulWidget {
  const AgentesPage({super.key});

  @override
  State<AgentesPage> createState() => _AgentesPageState();
}

class _AgentesPageState extends State<AgentesPage> {
  static const int pageSize = 10;

  late final PagingController<int, Agente> _pagingController;

  @override
  void initState() {
    super.initState();

    _pagingController = PagingController<int, Agente>(
      
      getNextPageKey: (state) {
        
        if (state.lastPageIsEmpty) {
          return null;
        }

        // 1, 2, 3, 4...
        return state.nextIntPageKey;
      },

      // Busca uma página nova.
      fetchPage: (pageKey) async {
        final repository =
            context.read<AgenteRepository>();

        final agentes = await repository.getAgentes(
          page: pageKey,
          limit: pageSize,
        );

        return agentes;
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agentes'),
        centerTitle: true,
      ),

      body: PagingListener(
        controller: _pagingController,

        builder: (
          context,
          state,
          fetchNextPage,
        ) {
          return RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
            },

            child: PagedListView<int, Agente>(
              state: state,
              fetchNextPage: fetchNextPage,

              builderDelegate:
                  PagedChildBuilderDelegate<Agente>(

                itemBuilder: (
                  context,
                  agente,
                  index,
                ) {
                  return AgentesCard(
                    agente: agente,
                  );
                },

           
                firstPageProgressIndicatorBuilder:
                    (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },

                // Carregando páginas seguintes
                newPageProgressIndicatorBuilder:
                    (context) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },

                firstPageErrorIndicatorBuilder:
                    (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Erro ao carregar agentes',
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {
                            _pagingController.refresh();
                          },
                          child: const Text(
                            'Tentar novamente',
                          ),
                        ),
                      ],
                    ),
                  );
                },

                newPageErrorIndicatorBuilder:
                    (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20),

                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _pagingController.fetchNextPage();
                        },
                        child: const Text(
                          'Tentar carregar mais',
                        ),
                      ),
                    ),
                  );
                },

                noItemsFoundIndicatorBuilder:
                    (context) {
                  return const Center(
                    child: Text(
                      'Nenhum agente encontrado',
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}