import '../../domain/agente.dart';
import 'entity/http_paged_result.dart';

class NetworkMapper {
  List<Agente> toAgentes(
    HttpPagedResult networkData,
  ) {
    return networkData.data.map((item) {
      return Agente.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}