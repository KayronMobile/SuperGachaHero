import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

import '../../domain/agente.dart';

class DetalhesAgentesPage extends StatelessWidget {
  final Agente agente;

  const DetalhesAgentesPage({
    super.key,
    required this.agente,
  });

  Widget buildPowerStat(
    BuildContext context,
    String nome,
    int valor,
  ) {
    final segments = [
      Segment(
        value: valor,
        color: Theme.of(context).colorScheme.primary,
        label: Text(nome),
        valueLabel: Text('$valor/100'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PrimerProgressBar(
        segments: segments,
        maxTotalValue: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(agente.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // IMAGEM GRANDE
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),

                child: CachedNetworkImage(
                  imageUrl: agente.images.lg,

                  width: 280,
                  height: 380,

                  fit: BoxFit.cover,

                  placeholder: (context, url) {
                    return const SizedBox(
                      width: 280,
                      height: 380,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },

                  errorWidget: (context, url, error) {
                    return const SizedBox(
                      width: 280,
                      height: 380,
                      child: Icon(
                        Icons.person,
                        size: 100,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // NOME
            Center(
              child: Text(
                agente.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // INFORMAÇÕES
            const Text(
              "Informações",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              "ID: ${agente.id}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Raça: ${agente.appearance.race}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Gênero: ${agente.appearance.gender}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Altura: ${agente.appearance.height.join(' / ')}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Peso: ${agente.appearance.weight.join(' / ')}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Cor dos olhos: ${agente.appearance.eyeColor}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Cor do cabelo: ${agente.appearance.hairColor}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // POWERSTATS
            const Text(
              "Powerstats",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            buildPowerStat(
              context,
              "Inteligência",
              agente.powerstats.intelligence,
            ),

            buildPowerStat(
              context,
              "Força",
              agente.powerstats.strength,
            ),

            buildPowerStat(
              context,
              "Velocidade",
              agente.powerstats.speed,
            ),

            buildPowerStat(
              context,
              "Durabilidade",
              agente.powerstats.durability,
            ),

            buildPowerStat(
              context,
              "Poder",
              agente.powerstats.power,
            ),

            buildPowerStat(
              context,
              "Combate",
              agente.powerstats.combat,
            ),
          ],
        ),
      ),
    );
  }
}