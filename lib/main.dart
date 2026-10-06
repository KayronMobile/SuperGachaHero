import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/page/sala_de_reuniao.dart';
import 'core/di/configure_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(
    AppRoot(data: data),
  );
}

class AppRoot extends StatelessWidget {
  final ConfigureProviders data;

  const AppRoot({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Super Gacha Hero',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),

        home: const SalaDeReuniao(),
      ),
    );
  }
}