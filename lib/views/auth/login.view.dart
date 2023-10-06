import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: AppPaddings.scaffoldPadding,
            child: Form(
              key: ref.watch(loginFormProvider).formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    height: 200,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    controller: ref.watch(loginFormProvider).emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    controller: ref.watch(loginFormProvider).passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: ref.watch(loginFormProvider).submit,
                    child: const Text(
                      "Login",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
