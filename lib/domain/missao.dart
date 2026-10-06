import 'agente.dart';

enum AtributoMissao {
  intelligence,
  strength,
  speed,
  durability,
  power,
  combat,
}

extension AtributoMissaoExtension on AtributoMissao {
  String get nome {
    switch (this) {
      case AtributoMissao.intelligence:
        return 'Inteligência';

      case AtributoMissao.strength:
        return 'Força';

      case AtributoMissao.speed:
        return 'Velocidade';

      case AtributoMissao.durability:
        return 'Durabilidade';

      case AtributoMissao.power:
        return 'Poder';

      case AtributoMissao.combat:
        return 'Combate';
    }
  }

  int valorDoAgente(Agente agente) {
    switch (this) {
      case AtributoMissao.intelligence:
        return agente.powerstats.intelligence;

      case AtributoMissao.strength:
        return agente.powerstats.strength;

      case AtributoMissao.speed:
        return agente.powerstats.speed;

      case AtributoMissao.durability:
        return agente.powerstats.durability;

      case AtributoMissao.power:
        return agente.powerstats.power;

      case AtributoMissao.combat:
        return agente.powerstats.combat;
    }
  }
}

enum ResultadoRodada {
  vitoria,
  derrota,
  empate,
}

class RodadaMissao {
  final Agente inimigo;
  final AtributoMissao atributo;

  Agente? agenteEscolhido;
  ResultadoRodada? resultado;

  RodadaMissao({
    required this.inimigo,
    required this.atributo,
  });
}

class Missao {
  final List<RodadaMissao> rodadas;

  final List<Agente> agentesUsados = [];

  int rodadaAtual = 0;

  Missao({
    required this.rodadas,
  });

  bool get finalizada {
    return rodadaAtual >= rodadas.length;
  }

  RodadaMissao? get rodada {
    if (finalizada) {
      return null;
    }

    return rodadas[rodadaAtual];
  }

  int get totalVitorias {
    return rodadas
        .where(
          (rodada) =>
              rodada.resultado ==
              ResultadoRodada.vitoria,
        )
        .length;
  }

  int get totalDerrotas {
    return rodadas
        .where(
          (rodada) =>
              rodada.resultado ==
              ResultadoRodada.derrota,
        )
        .length;
  }

  int get totalEmpates {
    return rodadas
        .where(
          (rodada) =>
              rodada.resultado ==
              ResultadoRodada.empate,
        )
        .length;
  }

  bool get venceu {
    return totalVitorias >
        rodadas.length / 2;
  }
}

class ResultadoPowerUp {
  final Agente agente;

  final AtributoMissao atributo;

  final int valorAnterior;

  final int valorNovo;

  ResultadoPowerUp({
    required this.agente,
    required this.atributo,
    required this.valorAnterior,
    required this.valorNovo,
  });
}