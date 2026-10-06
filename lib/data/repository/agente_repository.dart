import '../../domain/agente.dart';

abstract class AgenteRepository {
  Future<List<Agente>> getAgentes({
    required int page,
    required int limit,
  });
} 