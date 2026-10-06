/*import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/database/dao/Agentes_DAO.dart';
import '../../data/network/client/api_client.dart';
import '../../data/network/network_mapper.dart';
import '../../data/repository/Agente_repository_impl.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final api_client = ApiClient(baseUrl: "http://192.168.100.131:3000");
    final network_mapper = NetworkMapper();
    final agente_dao = AgentesDAO();

    final Agentes_repository = AgenteRepositoryImpl(
        apiClient: api_client,
        networkMapper: network_mapper,
        agenteDao: agente_dao
    );

    return ConfigureProviders(providers: [
      Provider<ApiClient>.value(value: api_client),
      Provider<NetworkMapper>.value(value: network_mapper),
      Provider<AgentesDAO>.value(value: agente_dao),
      Provider<AgenteRepositoryImpl>.value(value: Agentes_repository),
    ]);
  }
}*/

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/database/dao/Agentes_DAO.dart';
import '../../data/network/client/api_client.dart';
import '../../data/network/network_mapper.dart';

import '../../data/repository/agente_repository.dart';
import '../../data/repository/agente_repository_impl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/preferences/gacha_preferences.dart';
import '../../data/database/dao/Esquadrao_dao.dart';

import '../../data/repository/gacha_repository.dart';
import '../../data/repository/gacha_repository_impl.dart';

import '../../data/repository/esquadrao_repository.dart';
import '../../data/repository/esquadrao_repository_impl.dart';

import '../../data/repository/missao_repository.dart';
import '../../data/repository/missao_repository_impl.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final apiClient = ApiClient(baseUrl: "http://192.168.0.11:3000");
    final networkMapper = NetworkMapper();

    final agenteDao = AgentesDAO();
    final esquadraoDao = EsquadraoDAO();

    final sharedPreferences = await SharedPreferences.getInstance();
    final gachaPreferences = GachaPreferences(sharedPreferences);
    await gachaPreferences.inicializarPrimeiroAcesso();

    final agenteRepository = AgenteRepositoryImpl(
      apiClient: apiClient,
      networkMapper: networkMapper,
      agenteDao: agenteDao,
    );

    final esquadraoRepository = EsquadraoRepositoryImpl(esquadraoDao: esquadraoDao);

    final gachaRepository = GachaRepositoryImpl(
      agenteRepository: agenteRepository,
      gachaPreferences: gachaPreferences,
    );

    final missaoRepository = MissaoRepositoryImpl(
      agenteRepository: agenteRepository,
      esquadraoRepository: esquadraoRepository,
    );

    return ConfigureProviders(providers: [
      Provider<ApiClient>.value(value: apiClient),
      Provider<NetworkMapper>.value(value: networkMapper),
      Provider<AgentesDAO>.value(value: agenteDao),
      Provider<EsquadraoDAO>.value(value: esquadraoDao),
      Provider<GachaPreferences>.value(value: gachaPreferences),
      Provider<AgenteRepository>.value(value: agenteRepository),
      Provider<EsquadraoRepository>.value(value: esquadraoRepository),
      Provider<GachaRepository>.value(value: gachaRepository),
      Provider<MissaoRepository>.value(value: missaoRepository),
    ]);
  }
}
