import 'package:flutter/material.dart';
import 'package:SuperGachaHero/domain/agente.dart';
import 'package:SuperGachaHero/ui/widgets/agentes_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/agente_repository_impl.dart';

class listaAgentesPage extends StatefulWidget {
  const listaAgentesPage({super.key});

  @override
  State<listaAgentesPage> createState() => _listaAgentesPageState();
}

class _listaAgentesPageState extends State<listaAgentesPage> {

  late final AgenteRepositoryImpl agentesRepo;
  late final PagingController<int, Agente> _pagingController = PagingController<int, Agente>(
    getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => agentesRepo.getAgentes(page: pageKey, limit: 10)
  );


  @override
  void initState() {
    super.initState();
    agentesRepo = Provider.of<AgenteRepositoryImpl>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agentes"),
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        body: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) => PagedListView<int, Agente>(
            state: state,
            fetchNextPage: fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, agente, index) => AgentesCard(agente: agente),
            ),
          ),
        )

        /*
      body: FutureBuilder(
          future: moviesRepo.getMovies(page: 1, limit: 10),
          builder: (context, snapshop) {
            if (snapshop.hasData) {
              return ListView(
                children: List.generate(
                  snapshop.data!.length,
                  (index) => MovieCard(movie: snapshop.data![index]),
                ),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),*/
        );

    /*
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
      ),
      body: FutureBuilder(
          future: moviesRepo.getMovies(),
          builder: (context, snapshop) {
            if (snapshop.hasData) {
              return ListView(
                children: List.generate(
                    snapshop.data!.length,
                    (index) => ListTile(
                          title: Text(snapshop.data![index].title),
                        )),
              );
            } else {
              return LinearProgressIndicator();
            }
          }),
    );
     */
  }
}
