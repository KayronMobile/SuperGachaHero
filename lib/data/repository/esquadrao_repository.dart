import '../../domain/agente.dart';

abstract class EsquadraoRepository {
  Future<List<Agente>> getAgentes();

  Future<int> getQuantidade();

  Future<bool> jaFoiRecrutado(int agenteId);

  Future<void> recrutar(Agente agente);

  Future<void> dispensar(int agenteId);
  
  Future<void> atualizarAgente(Agente agente,
);

}