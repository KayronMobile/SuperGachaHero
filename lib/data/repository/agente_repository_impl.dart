import '../../domain/agente.dart';

import '../database/dao/Agentes_DAO.dart';
import '../network/client/api_client.dart';
import '../network/network_mapper.dart';

import 'agente_repository.dart';

class AgenteRepositoryImpl implements AgenteRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final AgentesDAO agenteDao;

  AgenteRepositoryImpl({
    required this.agenteDao,
    required this.apiClient,
    required this.networkMapper,
  });

  @override
  Future<List<Agente>> getAgentes({
    required int page,
    required int limit,
  }) async {
    try {
      final networkEntity =
          await apiClient.getAgentes(
        page: page,
        limit: limit,
      );

      final agentes =
          networkMapper.toAgentes(
        networkEntity,
      );

      await agenteDao.salvarAgentes(
        agentes,
      );

      return agentes;
    } catch (e) {
      final agentesCache =
          await agenteDao.buscarAgentes(
        page: page,
        limit: limit,
      );

      if (agentesCache.isNotEmpty) {
        return agentesCache;
      }

      rethrow;
    }
  }
}