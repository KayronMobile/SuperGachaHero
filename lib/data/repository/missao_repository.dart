import '../../domain/agente.dart';
import '../../domain/missao.dart';

abstract class MissaoRepository {

  Future<Missao> iniciarMissao();

  ResultadoRodada batalhar({
    required Missao missao,
    required Agente agente,
  });

  Future<ResultadoPowerUp?>
      finalizarMissao(
    Missao missao,
  );
}