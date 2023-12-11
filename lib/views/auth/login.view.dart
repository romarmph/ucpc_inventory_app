import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: width > 500 ? 500 : width,
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
                        height: 100,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      const Text(
                        "UCPC Inventory",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      const Text(
                        "Welcome back...",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        controller:
                            ref.watch(loginFormProvider).emailController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                        ),
                        validator: ref.watch(loginFormProvider).validateEmail,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        controller:
                            ref.watch(loginFormProvider).passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(passwordVisibilityProvider.notifier)
                                  .update(
                                    (state) => !state,
                                  );
                            },
                            icon: _renderVisibilityIcon(
                              ref.watch(passwordVisibilityProvider),
                            ),
                          ),
                        ),
                        obscureText: ref.watch(passwordVisibilityProvider),
                        validator:
                            ref.watch(loginFormProvider).validatePassword,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      FilledButton(
                        onPressed: () {
                          final login =
                              ref.watch(loginFormProvider).emailController.text;
                          final password = ref
                              .watch(loginFormProvider)
                              .passwordController
                              .text;
                          if (ref
                              .watch(loginFormProvider)
                              .formKey
                              .currentState!
                              .validate()) {
                            _handleLogin(
                              login,
                              password,
                            );
                          }
                        },
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
        ),
      ),
    );
  }

  void _handleLogin(String login, String password) async {
    _showLoading();
    try {
      await AuthService.instance.signInWithEmailAndPassword(
        email: login,
        password: password,
      );
      Navigator.of(navigatorKey.currentContext!).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        _showLoginError("Invalid email address");
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        _showLoginError("Incorrect email or password");
      } else {
        _showLoginError("Unknown error");
      }
    }
  }

  void _showLoginError(String message) {
    Navigator.of(navigatorKey.currentContext!).pop();
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.error,
      title: "Login Error",
      text: message,
    );
  }

  void _showLoading() {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.loading,
      title: "Logging in",
      text: "Please wait...",
    );
  }

  Icon _renderVisibilityIcon(bool isObscure) {
    return Icon(
      isObscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
    );
  }
}
