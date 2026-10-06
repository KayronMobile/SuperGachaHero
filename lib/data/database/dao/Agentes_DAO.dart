import 'package:sqflite/sqflite.dart';

import '../../../domain/agente.dart';
import '../database_mapper.dart';
import 'base_dao.dart';

class AgentesDAO extends BaseDao {
  Future<void> salvarAgente(
    Agente agente,
  ) async {
    final db = await database;

    await db.insert(
      'agentes',
      DatabaseMapper.toMap(agente),

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> salvarAgentes(
    List<Agente> agentes,
  ) async {
    final db = await database;

    final batch = db.batch();

    for (final agente in agentes) {
      batch.insert(
        'agentes',
        DatabaseMapper.toMap(agente),

        conflictAlgorithm:
            ConflictAlgorithm.replace,
      );
    }

    await batch.commit(
      noResult: true,
    );
  }

  Future<List<Agente>> buscarAgentes({
  required int page,
  required int limit,
}) async {
  final db = await database;

  final offset = (page - 1) * limit;

  final result = await db.query(
    'agentes',
    orderBy: 'id ASC',
    limit: limit,
    offset: offset,
  );

  return result
      .map(
        (map) => DatabaseMapper.fromMap(map),
      )
      .toList();
}

  Future<Agente?> buscarAgentePorId(
    int id,
  ) async {
    final db = await database;

    final result = await db.query(
      'agentes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return DatabaseMapper.fromMap(
      result.first,
    );
  }

  Future<void> limparAgentes() async {
    final db = await database;

    await db.delete('agentes');
  }
}