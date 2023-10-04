import 'package:flutter/material.dart';
import 'exports.dart';

void main() {
  runApp(const ProviderScope(
    child: UCPCInventoryApp(),
  ));
}

class UCPCInventoryApp extends ConsumerWidget {
  const UCPCInventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'UCPC Inventory',
      theme: FlexThemeData.light(
        scheme: FlexScheme.blueWhale,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blueWhale,
      ),
      themeMode: ThemeMode.dark,
      initialRoute: RouteNames.login,
      routes: routes,
    );
  }
}
