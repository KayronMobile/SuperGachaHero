import '../../domain/agente.dart';
import '../database/dao/Esquadrao_dao.dart';
import 'esquadrao_repository.dart';

class EsquadraoRepositoryImpl implements EsquadraoRepository {

  final EsquadraoDAO esquadraoDao;

  EsquadraoRepositoryImpl({
    required this.esquadraoDao,
  });

  @override
  Future<List<Agente>> getAgentes() {
    return esquadraoDao.listar();
  }

  @override
  Future<int> getQuantidade() {
    return esquadraoDao.quantidade();
  }

  @override
  Future<bool> jaFoiRecrutado(
    int agenteId,
  ) {
    return esquadraoDao.jaFoiRecrutado(
      agenteId,
    );
  }

  @override
  Future<void> recrutar(
    Agente agente,
  ) {
    return esquadraoDao.recrutar(
      agente,
    );
  }

  @override
  Future<void> dispensar(
    int agenteId,
  ) {
    return esquadraoDao.dispensar(
      agenteId,
    );
  }
   @override
  Future<void> atualizarAgente(
    Agente agente,
  ) {
    return esquadraoDao.atualizarAgente(
      agente,
    );
  }
}