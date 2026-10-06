import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../domain/agente.dart';
import '../../data/repository/esquadrao_repository.dart';

class EsquadraoPage extends StatefulWidget {
  const EsquadraoPage({super.key});

  @override
  State<EsquadraoPage> createState() => _EsquadraoPageState();
}

class _EsquadraoPageState extends State<EsquadraoPage> {
  List<Agente> agentes = [];

  bool carregando = true;

  String? erro;

  @override
  void initState() {
    super.initState();

    _carregarEsquadrao();
  }

  Future<void> _carregarEsquadrao() async {
    try {
      final repository =
          context.read<EsquadraoRepository>();

      final resultado =
          await repository.getAgentes();

      if (!mounted) {
        return;
      }

      setState(() {
        agentes = resultado;

        carregando = false;

        erro = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        carregando = false;

        erro = e.toString();
      });
    }
  }

  Future<void> _dispensar(
    Agente agente,
  ) async {
    try {
      final repository =
          context.read<EsquadraoRepository>();

      await repository.dispensar(
        agente.id,
      );

      await _carregarEsquadrao();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${agente.name} foi dispensado.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao dispensar agente: $e',
          ),
        ),
      );
    }
  }

  void _confirmarDispensa(
    Agente agente,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Dispensar agente?',
      desc:
          'Deseja remover ${agente.name} do seu esquadrão?',
      btnCancelText: 'Cancelar',
      btnOkText: 'Dispensar',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _dispensar(agente);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Esquadrão',
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: _carregarEsquadrao,

        child: _conteudo(),
      ),
    );
  }

  Widget _conteudo() {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (erro != null) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        children: [
          const SizedBox(
            height: 200,
          ),

          const Icon(
            Icons.error_outline,
            size: 60,
          ),

          const SizedBox(
            height: 16,
          ),

          Center(
            child: Text(
              'Erro ao carregar esquadrão\n$erro',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    if (agentes.isEmpty) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),

        children: const [
          SizedBox(
            height: 180,
          ),

          Icon(
            Icons.groups_outlined,
            size: 80,
          ),

          SizedBox(
            height: 20,
          ),

          Center(
            child: Text(
              'Seu esquadrão está vazio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 8,
          ),

          Center(
            child: Text(
              'Recrute agentes no Contrato Diário.',
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.all(16),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                'Agentes recrutados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                '${agentes.length}/15',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(),

            padding:
                const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
            ),

            itemCount: agentes.length,

            itemBuilder:
                (context, index) {
              final agente =
                  agentes[index];

              return _cardAgente(
                agente,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cardAgente(
    Agente agente,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      clipBehavior:
          Clip.antiAlias,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [
          SizedBox(
            height: 220,

            child: CachedNetworkImage(
              imageUrl:
                  agente.images.md,

              fit: BoxFit.cover,

              placeholder:
                  (context, url) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              },

              errorWidget:
                  (context, url, error) {
                return const Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  agente.name,
                  style:
                      const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: [
                    _atributo(
                      'FOR',
                      agente.powerstats
                          .strength,
                    ),

                    _atributo(
                      'INT',
                      agente.powerstats
                          .intelligence,
                    ),

                    _atributo(
                      'VEL',
                      agente.powerstats
                          .speed,
                    ),

                    _atributo(
                      'RES',
                      agente.powerstats
                          .durability,
                    ),

                    _atributo(
                      'POD',
                      agente.powerstats
                          .power,
                    ),

                    _atributo(
                      'COM',
                      agente.powerstats
                          .combat,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      _confirmarDispensa(
                        agente,
                      );
                    },

                    icon: const Icon(
                      Icons.person_remove,
                    ),

                    label:
                        const Text(
                      'Dispensar agente',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _atributo(
    String nome,
    int valor,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),

        border:
            Border.all(
          color: Colors.grey,
        ),
      ),

      child: Text(
        '$nome: $valor',
      ),
    );
  }
}