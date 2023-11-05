import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateChangesProvider).when(
          data: (user) {
            if (user == null) {
              ref.watch(loginFormProvider).reset();
              return const LoginPage();
            } else {
              return const HomePage();
            }
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => const Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          ),
        );
  }
}
