import 'package:sqflite/sqflite.dart';

import '../../../domain/agente.dart';
import '../database_mapper.dart';
import 'base_dao.dart';

class EsquadraoDAO extends BaseDao {

  Future<List<Agente>> listar() async {
    final db = await database;

    final resultado = await db.query(
      'esquadrao',
      orderBy: 'id ASC',
    );

    return resultado
        .map(
          (map) =>
              DatabaseMapper.fromMap(map),
        )
        .toList();
  }

  Future<int> quantidade() async {
    final db = await database;

    final resultado = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM esquadrao',
    );

    return Sqflite.firstIntValue(
          resultado,
        ) ??
        0;
  }

  Future<bool> jaFoiRecrutado(
    int agenteId,
  ) async {
    final db = await database;

    final resultado = await db.query(
      'esquadrao',
      where: 'id = ?',
      whereArgs: [agenteId],
      limit: 1,
    );

    return resultado.isNotEmpty;
  }

  Future<void> recrutar(
    Agente agente,
  ) async {
    final total = await quantidade();

    if (total >= 15) {
      throw Exception(
        'O esquadrão já possui 15 agentes.',
      );
    }

    final jaExiste =
        await jaFoiRecrutado(agente.id);

    if (jaExiste) {
      throw Exception(
        '${agente.name} já está no esquadrão.',
      );
    }

    final db = await database;

    await db.insert(
      'esquadrao',
      DatabaseMapper.toMap(agente),

      conflictAlgorithm:
          ConflictAlgorithm.ignore,
    );
  }

  Future<void> dispensar(
    int agenteId,
  ) async {
    final db = await database;

    await db.delete(
      'esquadrao',
      where: 'id = ?',
      whereArgs: [agenteId],
    );
  }
  Future<void> atualizarAgente(
  Agente agente,
  ) async {

    final db = await database;

    await db.insert(
      'esquadrao',
      DatabaseMapper.toMap(agente),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }
}