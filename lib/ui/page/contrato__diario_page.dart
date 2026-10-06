import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repository/esquadrao_repository.dart';
import '../../data/preferences/gacha_preferences.dart';
import '../../data/repository/agente_repository.dart';
import '../../domain/agente.dart';

class ContratoDiarioPage extends StatefulWidget {
  const ContratoDiarioPage({
    super.key,
  });

  @override
  State<ContratoDiarioPage> createState() =>
      _ContratoDiarioPageState();
}

class _ContratoDiarioPageState
    extends State<ContratoDiarioPage> {

  Agente? agenteAtual;

  bool carregando = true;

  int gachas = 0;

  @override
  void initState() {
    super.initState();

    _inicializar();
  }

  Future<void> _inicializar() async {
    final preferences =
        context.read<GachaPreferences>();

    await preferences
        .inicializarPrimeiroAcesso();

    gachas =
        preferences.gachasRestantes;

    final agenteId =
        preferences.agenteSorteadoHoje;

    if (agenteId != null) {
      final repository =
          context.read<AgenteRepository>();

      final agentes =
          await repository.getAgentes(
        page: 1,
        limit: 1000,
      );

      for (final agente in agentes) {
        if (agente.id == agenteId) {
          agenteAtual = agente;
          break;
        }
      }
    }

    // Primeiro sorteio do dia é gratuito
    if (agenteAtual == null) {
      await _sortear(
        gastarGacha: false,
      );
    }

    if (mounted) {
      setState(() {
        carregando = false;
      });
    }
  }

  Future<void> _sortear({
    required bool gastarGacha,
  }) async {

    final preferences =
        context.read<GachaPreferences>();

    if (gastarGacha) {
      final conseguiu =
          await preferences.consumirGacha();

      if (!conseguiu) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Você não possui mais Gachas.',
            ),
          ),
        );

        return;
      }
    }

    setState(() {
      carregando = true;
    });

    try {
      final repository =
          context.read<AgenteRepository>();

      final agentes =
          await repository.getAgentes(
        page: 1,
        limit: 1000,
      );

      if (agentes.isEmpty) {
        throw Exception(
          'Nenhum agente disponível.',
        );
      }

      final random = Random();

      Agente sorteado;

      do {
        sorteado =
            agentes[
                random.nextInt(
                  agentes.length,
                )
            ];
      } while (
          agentes.length > 1 &&
          sorteado.id == agenteAtual?.id
      );

      agenteAtual = sorteado;

      await preferences.registrarSorteio(
        sorteado.id,
      );

      gachas =
          preferences.gachasRestantes;

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao sortear agente: $e',
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        carregando = false;
      });
    }
  }

  Future<void> _recrutar() async {
    final agente = agenteAtual;

    if (agente == null) {
      return;
    }

    final repository =
    context.read<EsquadraoRepository>();
    try {
      await repository.recrutar(
        agente,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${agente.name} foi recrutado!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Contrato Diário'),
      ),

      body: carregando
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : agenteAtual == null
              ? const Center(
                  child: Text(
                    'Nenhum agente disponível',
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.casino,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Text(
                            'Gachas: $gachas',
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      CachedNetworkImage(
                        imageUrl:
                            agenteAtual!.images.lg,

                        height: 350,

                        fit: BoxFit.cover,

                        placeholder:
                            (_, __) =>
                                const Center(
                          child:
                              CircularProgressIndicator(),
                        ),

                        errorWidget:
                            (_, __, ___) =>
                                const Icon(
                          Icons.person,
                          size: 150,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        agenteAtual!.name,
                        style:
                            const TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        'Inteligência: '
                        '${agenteAtual!.powerstats.intelligence}',
                      ),

                      Text(
                        'Força: '
                        '${agenteAtual!.powerstats.strength}',
                      ),

                      Text(
                        'Velocidade: '
                        '${agenteAtual!.powerstats.speed}',
                      ),

                      Text(
                        'Durabilidade: '
                        '${agenteAtual!.powerstats.durability}',
                      ),

                      Text(
                        'Poder: '
                        '${agenteAtual!.powerstats.power}',
                      ),

                      Text(
                        'Combate: '
                        '${agenteAtual!.powerstats.combat}',
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      SizedBox(
                        width: double.infinity,

                        child:
                            ElevatedButton.icon(
                          onPressed:
                              _recrutar,

                          icon: const Icon(
                            Icons.person_add,
                          ),

                          label: const Text(
                            'Recrutar para o Esquadrão',
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      SizedBox(
                        width: double.infinity,

                        child:
                            OutlinedButton.icon(
                          onPressed:
                              gachas > 0
                                  ? () =>
                                      _sortear(
                                        gastarGacha:
                                            true,
                                      )
                                  : null,

                          icon: const Icon(
                            Icons.casino,
                          ),

                          label: Text(
                            'Girar novamente ($gachas)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}