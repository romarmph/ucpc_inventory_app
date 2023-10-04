import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';
import 'package:ucpc_inventory_management_app/riverpod/auth/auth.riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.scaffoldPadding,
          child: Form(
            key: ref.watch(loginFormProvider).formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: ref.watch(loginFormProvider).emailController,
                ),
                TextFormField(
                  controller: ref.watch(loginFormProvider).passwordController,
                ),
                ElevatedButton(
                  onPressed: ref.watch(loginFormProvider).submit,
                  child: const Text(
                    "Login",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
