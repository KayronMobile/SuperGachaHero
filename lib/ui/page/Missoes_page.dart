import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../domain/agente.dart';
import '../../domain/missao.dart';

import '../../data/repository/esquadrao_repository.dart';
import '../../data/repository/missao_repository.dart';

import '../widgets/atributo_agente.dart';

class MissoesPage extends StatefulWidget {
  const MissoesPage({super.key});

  @override
  State<MissoesPage> createState() =>
      _MissoesPageState();
}

class _MissoesPageState
    extends State<MissoesPage> {
  List<Agente> _esquadrao = [];

  Missao? _missao;

  Agente? _agenteSelecionado;

  bool _carregando = true;
  bool _batalhando = false;

  String? _resultadoRodada;

  @override
  void initState() {
    super.initState();

    _carregarEsquadrao();
  }

  // ==========================================
  // CARREGA O ESQUADRÃO
  // ==========================================

  Future<void> _carregarEsquadrao() async {
    try {
      final repository =
          context.read<EsquadraoRepository>();

      final agentes =
          await repository.getAgentes();

      if (!mounted) {
        return;
      }

      setState(() {
        _esquadrao = agentes;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao carregar esquadrão: $e',
          ),
        ),
      );
    }
  }

  // ==========================================
  // INICIAR MISSÃO
  // ==========================================

  Future<void> _iniciarMissao() async {
    if (_esquadrao.length < 5) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Esquadrão insuficiente',
        desc:
            'Você precisa de pelo menos 5 agentes para iniciar uma missão.',
        btnOkText: 'Entendi',
        btnOkOnPress: () {},
      ).show();

      return;
    }

    try {
      setState(() {
        _carregando = true;
        _resultadoRodada = null;
        _agenteSelecionado = null;
      });

      final repository =
          context.read<MissaoRepository>();

      final missao =
          await repository.iniciarMissao();

      if (!mounted) {
        return;
      }

      setState(() {
        _missao = missao;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _carregando = false;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Erro',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  // ==========================================
  // SELECIONAR AGENTE
  // ==========================================

  void _selecionarAgente(
    Agente agente,
  ) {
    if (_batalhando) {
      return;
    }

    if (_agenteJaUsado(agente)) {
      return;
    }

    setState(() {
      _agenteSelecionado = agente;
    });
  }

  bool _agenteJaUsado(
    Agente agente,
  ) {
    if (_missao == null) {
      return false;
    }

    return _missao!.agentesUsados.any(
      (usado) =>
          usado.id == agente.id,
    );
  }

  // ==========================================
  // BATALHAR
  // ==========================================

  Future<void> _batalhar() async {
    if (_missao == null ||
        _agenteSelecionado == null ||
        _batalhando) {
      return;
    }

    setState(() {
      _batalhando = true;
      _resultadoRodada = null;
    });

    try {
      final repository =
          context.read<MissaoRepository>();

      final resultado =
          repository.batalhar(
        missao: _missao!,
        agente: _agenteSelecionado!,
      );

      String mensagem;

      switch (resultado) {
        case ResultadoRodada.vitoria:
          mensagem =
              'VITÓRIA NA RODADA!';
          break;

        case ResultadoRodada.derrota:
          mensagem =
              'DERROTA NA RODADA!';
          break;

        case ResultadoRodada.empate:
          mensagem =
              'EMPATE TÁTICO!';
          break;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _resultadoRodada = mensagem;
      });

      await Future.delayed(
        const Duration(
          milliseconds: 1200,
        ),
      );

      if (!mounted) {
        return;
      }

      if (_missao!.finalizada) {
        await _finalizarMissao();

        return;
      }

      setState(() {
        _agenteSelecionado = null;
        _resultadoRodada = null;
        _batalhando = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _batalhando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ==========================================
  // FINALIZAR MISSÃO
  // ==========================================

  Future<void> _finalizarMissao() async {
    try {
      final repository =
          context.read<MissaoRepository>();

      final powerUp =
          await repository.finalizarMissao(
        _missao!,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _batalhando = false;
      });

      if (_missao!.venceu &&
          powerUp != null) {
        await _dialogVitoria(
          powerUp,
        );
      } else {
        await _dialogDerrota();
      }

      await _carregarEsquadrao();

      if (!mounted) {
        return;
      }

      setState(() {
        _missao = null;
        _agenteSelecionado = null;
        _resultadoRodada = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _batalhando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao finalizar missão: $e',
          ),
        ),
      );
    }
  }

  // ==========================================
  // DIALOG DE VITÓRIA
  // ==========================================

  Future<void> _dialogVitoria(
    ResultadoPowerUp powerUp,
  ) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Missão Cumprida!',
      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: [
            const Text(
              'MISSÃO CUMPRIDA!',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    powerUp.agente.images.md,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) {
                  return const SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  );
                },
                errorWidget:
                    (
                      context,
                      url,
                      error,
                    ) {
                  return const SizedBox(
                    width: 120,
                    height: 120,
                    child: Icon(
                      Icons.person,
                      size: 80,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              powerUp.agente.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'POWER UP!',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              '${powerUp.atributo.nome}: '
              '${powerUp.valorAnterior} '
              '→ '
              '${powerUp.valorNovo}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              'Vitórias: '
              '${_missao!.totalVitorias}'
              '\nDerrotas: '
              '${_missao!.totalDerrotas}'
              '\nEmpates: '
              '${_missao!.totalEmpates}',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
      btnOkText: 'Continuar',
      btnOkOnPress: () {},
    ).show();
  }

  // ==========================================
  // DIALOG DE DERROTA
  // ==========================================

  Future<void> _dialogDerrota() async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title:
          'Operação Fracassada!',
      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 90,
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'OPERAÇÃO FRACASSADA!',
              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            Text(
              'Vitórias: '
              '${_missao!.totalVitorias}'
              '\nDerrotas: '
              '${_missao!.totalDerrotas}'
              '\nEmpates: '
              '${_missao!.totalEmpates}',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      btnOkText: 'Voltar',
      btnOkOnPress: () {},
    ).show();
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Missões'),
        centerTitle: true,
      ),
      body: _carregando
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _missao == null
              ? _telaInicial()
              : _telaMissao(),
    );
  }

  // ==========================================
  // TELA INICIAL
  // ==========================================

  Widget _telaInicial() {
    final podeIniciar =
        _esquadrao.length >= 5;

    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 100,
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              'Central de Missões',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Envie seus agentes para enfrentar ameaças e testar o poder do seu esquadrão.',
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 30,
            ),

            Text(
              'Agentes disponíveis: '
              '${_esquadrao.length}/15',
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (!podeIniciar)
              const Text(
                'Você precisa de pelo menos 5 agentes para iniciar uma missão.',
                textAlign:
                    TextAlign.center,
              ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    podeIniciar
                        ? _iniciarMissao
                        : null,
                icon: const Icon(
                  Icons.play_arrow,
                ),
                label:
                    const Padding(
                  padding:
                      EdgeInsets.all(
                    14,
                  ),
                  child: Text(
                    'INICIAR MISSÃO',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TELA DA MISSÃO
  // ==========================================

  Widget _telaMissao() {
    final missao = _missao!;

    final rodada = missao.rodada;

    RodadaMissao? rodadaExibida =
        rodada;

    if (_resultadoRodada != null &&
        missao.rodadaAtual > 0) {
      rodadaExibida =
          missao.rodadas[
        missao.rodadaAtual - 1
      ];
    }

    if (rodadaExibida == null) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    int numeroRodada =
        missao.rodadaAtual + 1;

    if (_resultadoRodada != null) {
      numeroRodada =
          missao.rodadaAtual;
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),
            child: Column(
              children: [
                Text(
                  'ROUND $numeroRodada'
                  '/${missao.rodadas.length}',
                  style:
                      const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Vitórias: '
                  '${missao.totalVitorias} • '
                  'Derrotas: '
                  '${missao.totalDerrotas} • '
                  'Empates: '
                  '${missao.totalEmpates}',
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Column(
                children: [
                  const Text(
                    'AMEAÇA DETECTADA',
                    style:
                        TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                    child:
                        CachedNetworkImage(
                      imageUrl:
                          rodadaExibida
                              .inimigo
                              .images
                              .md,
                      height: 210,
                      width: 170,
                      fit:
                          BoxFit.cover,
                      placeholder:
                          (
                            context,
                            url,
                          ) {
                        return const SizedBox(
                          height: 210,
                          child: Center(
                            child:
                                CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorWidget:
                          (
                            context,
                            url,
                            error,
                          ) {
                        return const SizedBox(
                          height: 210,
                          width: 170,
                          child: Icon(
                            Icons.person,
                            size: 90,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    rodadaExibida
                        .inimigo
                        .name,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets.all(
                      14,
                    ),
                    decoration:
                        BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                      border:
                          Border.all(
                        color:
                            Colors.grey,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ATRIBUTO EM DISPUTA',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          rodadaExibida
                              .atributo
                              .nome,
                          style:
                              const TextStyle(
                            fontSize: 23,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  if (_resultadoRodada !=
                      null)
                    _resultadoWidget()
                  else ...[
                    const Text(
                      'ESCOLHA SEU AGENTE',
                      style:
                          TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    _gridAgentes(),

                    const SizedBox(
                      height: 18,
                    ),

                    // ==========================
                    // ATRIBUTO DO SELECIONADO
                    // ==========================

                    if (_agenteSelecionado !=
                        null)
                      AtributoAgenteWidget(
                        agente:
                            _agenteSelecionado!,
                        atributo:
                            rodadaExibida
                                .atributo,
                      ),

                    const SizedBox(
                      height: 24,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            _agenteSelecionado ==
                                        null ||
                                    _batalhando
                                ? null
                                : _batalhar,
                        icon:
                            const Icon(
                          Icons.flash_on,
                        ),
                        label:
                            const Padding(
                          padding:
                              EdgeInsets.all(
                            14,
                          ),
                          child: Text(
                            'BATALHAR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // GRID DOS AGENTES
  // ==========================================

  Widget _gridAgentes() {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
        childAspectRatio: 0.8,
      ),

      itemCount:
          _esquadrao.length,

      itemBuilder:
          (context, index) {
        final agente =
            _esquadrao[index];

        final usado =
            _agenteJaUsado(
          agente,
        );

        final selecionado =
            _agenteSelecionado?.id ==
                agente.id;

        return GestureDetector(
          onTap:
              usado || _batalhando
                  ? null
                  : () =>
                      _selecionarAgente(
                        agente,
                      ),

          child: Opacity(
            opacity:
                usado
                    ? 0.35
                    : 1,

            child: Container(
              padding:
                  const EdgeInsets.all(
                8,
              ),

              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                border:
                    Border.all(
                  width:
                      selecionado
                          ? 3
                          : 1,

                  color:
                      selecionado
                          ? Theme.of(
                              context,
                            )
                              .colorScheme
                              .primary
                          : Colors.grey,
                ),
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child:
                            CachedNetworkImage(
                          imageUrl:
                              agente
                                  .images
                                  .sm,
                          width: 65,
                          height: 65,
                          fit:
                              BoxFit.cover,
                          errorWidget:
                              (
                                context,
                                url,
                                error,
                              ) =>
                                  const Icon(
                            Icons.person,
                            size: 60,
                          ),
                        ),
                      ),

                      if (usado)
                        const Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.check_circle,
                              size: 35,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    agente.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (usado)
                    const Text(
                      'USADO',
                      style:
                          TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // RESULTADO DA RODADA
  // ==========================================

  Widget _resultadoWidget() {
    IconData icone;

    if (_resultadoRodada!
        .contains('VITÓRIA')) {
      icone =
          Icons.check_circle;
    } else if (_resultadoRodada!
        .contains('EMPATE')) {
      icone =
          Icons.handshake;
    } else {
      icone =
          Icons.cancel;
    }

    return Column(
      children: [
        Icon(
          icone,
          size: 70,
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          _resultadoRodada!,
          textAlign:
              TextAlign.center,
          style:
              const TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        const Text(
          'Preparando próxima rodada...',
        ),

        const SizedBox(
          height: 16,
        ),

        const CircularProgressIndicator(),
      ],
    );
  }
}