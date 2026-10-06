import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../page/detalhes_agentes_page.dart';
import '../../domain/agente.dart';

class AgentesCard extends StatelessWidget {
  final Agente agente;

  const AgentesCard({
    super.key,
    required this.agente,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      elevation: 3,

      child: InkWell(
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetalhesAgentesPage(
        agente: agente,
      ),
    ),
  );
},

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            children: [

              // FOTO
              ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: CachedNetworkImage(
                  imageUrl: agente.images.sm,

                  width: 90,
                  height: 120,

                  fit: BoxFit.cover,

                  placeholder: (context, url) {
                    return const SizedBox(
                      width: 90,
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },

                  errorWidget: (context, url, error) {
                    return const SizedBox(
                      width: 90,
                      height: 120,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // INFORMAÇÕES
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      agente.name,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Raça: ${agente.appearance.race}",
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Inteligência: "
                      "${agente.powerstats.intelligence}",
                    ),

                    Text(
                      "Força: "
                      "${agente.powerstats.strength}",
                    ),

                    Text(
                      "Combate: "
                      "${agente.powerstats.combat}",
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}