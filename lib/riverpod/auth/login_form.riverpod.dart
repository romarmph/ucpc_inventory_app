import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class LoginFormProvider {
  LoginFormProvider(this.ref);
  final ProviderRef ref;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void reset() {
    emailController.clear();
    passwordController.clear();
    isObscure = true;
  }
}

final loginFormProvider = Provider<LoginFormProvider>((ref) {
  return LoginFormProvider(ref);
});

final passwordVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
