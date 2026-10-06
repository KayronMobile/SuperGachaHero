import 'package:shared_preferences/shared_preferences.dart';

class GachaPreferences {
  final SharedPreferences prefs;

  GachaPreferences(this.prefs);

  static const String _gachasKey = 'gachas_restantes';
  static const String _primeiroAcessoKey = 'primeiro_acesso_configurado';

  static const String _ultimaDataKey = 'ultima_data_sorteio';
  static const String _ultimoAgenteKey = 'ultimo_agente_sorteado';

  Future<void> inicializarPrimeiroAcesso() async {
    final configurado =
        prefs.getBool(_primeiroAcessoKey) ?? false;

    if (!configurado) {
      // Bônus inicial
      await prefs.setInt(
        _gachasKey,
        5,
      );

      await prefs.setBool(
        _primeiroAcessoKey,
        true,
      );
    }
  }

  int get gachasRestantes {
    return prefs.getInt(_gachasKey) ?? 0;
  }

  String _dataHoje() {
    final hoje = DateTime.now();

    final mes =
        hoje.month.toString().padLeft(2, '0');

    final dia =
        hoje.day.toString().padLeft(2, '0');

    return '${hoje.year}-$mes-$dia';
  }

  bool get jaSorteouHoje {
    final ultimaData =
        prefs.getString(_ultimaDataKey);

    return ultimaData == _dataHoje();
  }

  int? get agenteSorteadoHoje {
    if (!jaSorteouHoje) {
      return null;
    }

    return prefs.getInt(
      _ultimoAgenteKey,
    );
  }

  Future<void> registrarSorteio(
    int agenteId,
  ) async {
    await prefs.setString(
      _ultimaDataKey,
      _dataHoje(),
    );

    await prefs.setInt(
      _ultimoAgenteKey,
      agenteId,
    );
  }

  Future<bool> consumirGacha() async {
    final atual = gachasRestantes;

    if (atual <= 0) {
      return false;
    }

    await prefs.setInt(
      _gachasKey,
      atual - 1,
    );

    return true;
  }
}