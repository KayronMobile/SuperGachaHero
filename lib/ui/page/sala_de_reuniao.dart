import 'package:flutter/material.dart';

import 'agentes_page.dart';
import 'contrato__diario_page.dart';
import 'esquadrao_page.dart';
import 'Missoes_page.dart';

class SalaDeReuniao extends StatelessWidget {
  const SalaDeReuniao({super.key});

  void abrirTela(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => tela,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Central de Agentes"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.shield,
              size: 100,
            ),

            const SizedBox(height: 30),

            const Text(
              "Central de Operações",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text("Agentes"),

                onPressed: () {
                  abrirTela(
                    context,
                    const AgentesPage(),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("Contrato Diário"),

                onPressed: () {
                  abrirTela(
                    context,
                    const ContratoDiarioPage(),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.groups),
                label: const Text("Meu Esquadrão"),

                onPressed: () {
                  abrirTela(
                    context,
                    const EsquadraoPage(),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flash_on),
                label: const Text("Missões"),

                onPressed: () {
                  abrirTela(
                    context,
                    const MissoesPage(),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}