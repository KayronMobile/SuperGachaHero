import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/agente.dart';
import '../../domain/missao.dart';

class AtributoAgenteWidget extends StatelessWidget {
  final Agente agente;
  final AtributoMissao atributo;

  const AtributoAgenteWidget({
    super.key,
    required this.agente,
    required this.atributo,
  });

  @override
  Widget build(BuildContext context) {
    final valor =
        atributo.valorDoAgente(
      agente,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .primary,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: agente.images.sm,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorWidget:
                  (context, url, error) {
                return const SizedBox(
                  width: 55,
                  height: 55,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  agente.name,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  '${atributo.nome}: $valor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}