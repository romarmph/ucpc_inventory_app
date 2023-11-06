import 'package:ucpc_inventory_management_app/exports.dart';

class AuthService {
  const AuthService._();

  static const AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  User get currentUser => _auth.currentUser!;
  Stream<User?> get authState => _auth.authStateChanges();

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
