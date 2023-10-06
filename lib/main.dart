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
      navigatorKey: navigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.login,
      routes: routes,
    );
  }
}
