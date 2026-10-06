import 'dart:math';

import '../../domain/agente.dart';

import '../preferences/gacha_preferences.dart';

import 'agente_repository.dart';
import 'gacha_repository.dart';

class GachaRepositoryImpl
    implements GachaRepository {

  final AgenteRepository agenteRepository;

  final GachaPreferences gachaPreferences;

  final Random _random = Random();

  GachaRepositoryImpl({
    required this.agenteRepository,
    required this.gachaPreferences,
  });

  @override
  Future<void> inicializar() async {
    await gachaPreferences
        .inicializarPrimeiroAcesso();
  }

  @override
  int get gachasRestantes {
    return gachaPreferences.gachasRestantes;
  }

  Future<List<Agente>>
      _buscarAgentesDisponiveis() async {

    final agentes =
        await agenteRepository.getAgentes(
      page: 1,
      limit: 1000,
    );

    if (agentes.isEmpty) {
      throw Exception(
        'Nenhum agente disponível para sorteio.',
      );
    }

    return agentes;
  }

  Agente _sortear(
    List<Agente> agentes, {
    int? evitarId,
  }) {

    if (agentes.length == 1) {
      return agentes.first;
    }

    Agente sorteado;

    do {
      sorteado =
          agentes[
            _random.nextInt(
              agentes.length,
            )
          ];
    } while (
        evitarId != null &&
        sorteado.id == evitarId
    );

    return sorteado;
  }

  @override
  Future<Agente> getAgenteDoDia() async {
    await inicializar();

    final agentes =
        await _buscarAgentesDisponiveis();

    final agenteIdHoje =
        gachaPreferences
            .agenteSorteadoHoje;

    // Já houve sorteio hoje.
    if (agenteIdHoje != null) {

      for (final agente in agentes) {
        if (agente.id == agenteIdHoje) {
          return agente;
        }
      }
    }

    // Primeiro sorteio do dia:
    // NÃO gasta gacha.
    final sorteado =
        _sortear(agentes);

    await gachaPreferences
        .registrarSorteio(
      sorteado.id,
    );

    return sorteado;
  }

  @override
  Future<Agente> girarNovamente() async {
    await inicializar();

    if (gachasRestantes <= 0) {
      throw Exception(
        'Você não possui mais Gachas.',
      );
    }

    final agentes =
        await _buscarAgentesDisponiveis();

    final agenteAnterior =
        gachaPreferences
            .agenteSorteadoHoje;

    final conseguiuGastar =
        await gachaPreferences
            .consumirGacha();

    if (!conseguiuGastar) {
      throw Exception(
        'Você não possui mais Gachas.',
      );
    }

    final sorteado = _sortear(
      agentes,
      evitarId: agenteAnterior,
    );

    await gachaPreferences
        .registrarSorteio(
      sorteado.id,
    );

    return sorteado;
  }
 
}