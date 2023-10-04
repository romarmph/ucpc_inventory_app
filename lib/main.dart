import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/firebase_options.dart';
import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
