import 'package:ucpc_inventory_management_app/exports.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authState;
});
