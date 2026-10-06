import '../../domain/agente.dart';

abstract class GachaRepository {
  Future<void> inicializar();

  int get gachasRestantes;

  Future<Agente> getAgenteDoDia();

  Future<Agente> girarNovamente();
}