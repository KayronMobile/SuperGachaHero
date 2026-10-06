import 'dart:convert';

import '../../domain/agente.dart';

class DatabaseMapper {
  static Map<String, dynamic> toMap(Agente agente) {
    return {
      'id': agente.id,
      'data': jsonEncode(agente.toJson()),
    };
  }

  static Agente fromMap(Map<String, dynamic> map) {
    final json =
        jsonDecode(map['data'] as String)
            as Map<String, dynamic>;

    return Agente.fromJson(json);
  }
}