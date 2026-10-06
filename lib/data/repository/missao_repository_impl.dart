import 'dart:math';

import '../../domain/agente.dart';
import '../../domain/missao.dart';

import 'agente_repository.dart';
import 'esquadrao_repository.dart';
import 'missao_repository.dart';

class MissaoRepositoryImpl
    implements MissaoRepository {

  final AgenteRepository agenteRepository;

  final EsquadraoRepository
      esquadraoRepository;

  final Random _random = Random();

  MissaoRepositoryImpl({
    required this.agenteRepository,
    required this.esquadraoRepository,
  });

  @override
  Future<Missao> iniciarMissao() async {

    // ============================
    // CARREGA O ESQUADRÃO
    // ============================

    final esquadrao =
        await esquadraoRepository
            .getAgentes();

    if (esquadrao.length < 5) {
      throw Exception(
        'Você precisa de pelo menos 5 agentes para iniciar uma missão.',
      );
    }


    // ============================
    // CARREGA O CATÁLOGO
    // ============================

    final catalogo =
        await agenteRepository
            .getAgentes(
      page: 1,
      limit: 1000,
    );


    // IDs dos agentes do jogador

    final idsEsquadrao =
        esquadrao
            .map((agente) => agente.id)
            .toSet();


    // ============================
    // POSSÍVEIS INIMIGOS
    // ============================

    final inimigos =
        catalogo
            .where(
              (agente) =>
                  !idsEsquadrao
                      .contains(
                    agente.id,
                  ),
            )
            .toList();

    if (inimigos.isEmpty) {
      throw Exception(
        'Não existem inimigos disponíveis.',
      );
    }


    // ============================
    // 3 A 5 ROUNDS
    // ============================

    final quantidadeRounds =
        3 + _random.nextInt(3);

    final atributos =
        AtributoMissao.values;

    final rodadas =
        <RodadaMissao>[];


    // ============================
    // CRIA AS RODADAS
    // ============================

    for (
      int i = 0;
      i < quantidadeRounds;
      i++
    ) {

      final inimigo =
          inimigos[
            _random.nextInt(
              inimigos.length,
            )
          ];

      final atributo =
          atributos[
            _random.nextInt(
              atributos.length,
            )
          ];

      rodadas.add(
        RodadaMissao(
          inimigo: inimigo,
          atributo: atributo,
        ),
      );
    }

    return Missao(
      rodadas: rodadas,
    );
  }


  // ==================================
  // BATALHA
  // ==================================

  @override
  ResultadoRodada batalhar({
    required Missao missao,
    required Agente agente,
  }) {

    if (missao.finalizada) {
      throw Exception(
        'A missão já terminou.',
      );
    }


    // ============================
    // IMPEDE REPETIR AGENTE
    // ============================

    final jaFoiUsado =
        missao.agentesUsados.any(
      (usado) =>
          usado.id == agente.id,
    );

    if (jaFoiUsado) {
      throw Exception(
        'Este agente já participou desta missão.',
      );
    }


    final rodada =
        missao.rodada!;


    // ============================
    // PEGA O ATRIBUTO
    // ============================

    final valorHeroi =
        rodada.atributo
            .valorDoAgente(
      agente,
    );

    final valorInimigo =
        rodada.atributo
            .valorDoAgente(
      rodada.inimigo,
    );


    ResultadoRodada resultado;


    // ============================
    // COMPARAÇÃO
    // ============================

    if (valorHeroi >
        valorInimigo) {

      resultado =
          ResultadoRodada.vitoria;

    } else if (
        valorHeroi <
        valorInimigo) {

      resultado =
          ResultadoRodada.derrota;

    } else {

      resultado =
          ResultadoRodada.empate;
    }


    // ============================
    // REGISTRA PARTICIPAÇÃO
    // ============================

    rodada.agenteEscolhido =
        agente;

    rodada.resultado =
        resultado;

    missao.agentesUsados.add(
      agente,
    );


    // Próximo round

    missao.rodadaAtual++;


    return resultado;
  }


  // ==================================
  // FINAL DA MISSÃO
  // ==================================

  @override
  Future<ResultadoPowerUp?>
      finalizarMissao(
    Missao missao,
  ) async {

    if (!missao.finalizada) {
      throw Exception(
        'A missão ainda não terminou.',
      );
    }


    // Precisa ganhar mais da metade

    if (!missao.venceu) {
      return null;
    }


    // ==================================
    // SORTEIA SOMENTE ENTRE QUEM
    // PARTICIPOU DA MISSÃO
    // ==================================

    final agenteEscolhido =
        missao.agentesUsados[
          _random.nextInt(
            missao
                .agentesUsados
                .length,
          )
        ];


    // ==================================
    // ATRIBUTO ALEATÓRIO
    // ==================================

    final atributo =
        AtributoMissao.values[
          _random.nextInt(
            AtributoMissao
                .values
                .length,
          )
        ];


    final valorAnterior =
        atributo.valorDoAgente(
      agenteEscolhido,
    );


    // ==================================
    // +1 POWER UP
    // ==================================

    final agenteAtualizado =
        _aplicarPowerUp(
      agenteEscolhido,
      atributo,
    );


    // ==================================
    // SALVA NO SQLITE
    // ==================================

    await esquadraoRepository
        .atualizarAgente(
      agenteAtualizado,
    );


    return ResultadoPowerUp(
      agente:
          agenteAtualizado,

      atributo:
          atributo,

      valorAnterior:
          valorAnterior,

      valorNovo:
          valorAnterior + 1,
    );
  }


  // ==================================
  // APLICA +1
  // ==================================

  Agente _aplicarPowerUp(
    Agente agente,
    AtributoMissao atributo,
  ) {

    final stats =
        agente.powerstats;

    final novosStats =
        Powerstats(

      intelligence:
          stats.intelligence +
              (
                atributo ==
                        AtributoMissao
                            .intelligence
                    ? 1
                    : 0
              ),

      strength:
          stats.strength +
              (
                atributo ==
                        AtributoMissao
                            .strength
                    ? 1
                    : 0
              ),

      speed:
          stats.speed +
              (
                atributo ==
                        AtributoMissao
                            .speed
                    ? 1
                    : 0
              ),

      durability:
          stats.durability +
              (
                atributo ==
                        AtributoMissao
                            .durability
                    ? 1
                    : 0
              ),

      power:
          stats.power +
              (
                atributo ==
                        AtributoMissao
                            .power
                    ? 1
                    : 0
              ),

      combat:
          stats.combat +
              (
                atributo ==
                        AtributoMissao
                            .combat
                    ? 1
                    : 0
              ),
    );


    return Agente(
      id: agente.id,
      name: agente.name,
      slug: agente.slug,

      powerstats:
          novosStats,

      appearance:
          agente.appearance,

      images:
          agente.images,
    );
  }
}