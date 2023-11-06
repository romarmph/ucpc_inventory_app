import 'package:ucpc_inventory_management_app/exports.dart';

class UserDatabase {
  const UserDatabase._();

  static const UserDatabase _instance = UserDatabase._();
  static UserDatabase get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

  static final _userRef = _firestore.collection('users');

  Future<void> addUser(UserModel user, String password) async {
    final emailAlreadyExists = await _userRef
        .where(
          'email',
          isEqualTo: user.email,
        )
        .get()
        .then((value) => value.docs);

    if (emailAlreadyExists.isNotEmpty) {
      throw Exception(
        'email-already-exists',
      );
    }

    await _createUser(
      user.email,
      password,
    );

    final existingUserWithSameName = await _userRef
        .where(
          'name',
          isEqualTo: user.name,
        )
        .get()
        .then(
          (value) => value.docs,
        );
    if (existingUserWithSameName.isNotEmpty) {
      throw Exception(
        'user-already-exists',
      );
    }

    await _userRef.add(user.toJson());
  }

  Future _createUser(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateUser(UserModel user) async {
    final emailAlreadyExists = await _userRef
        .where(
          'email',
          isEqualTo: user.email,
        )
        .get()
        .then((value) => value.docs);

    if (emailAlreadyExists.isNotEmpty &&
        emailAlreadyExists.first.id != user.id) {
      throw Exception(
        'email-already-exists',
      );
    }

    final existingUserWithSameName = await _userRef
        .where(
          'name',
          isEqualTo: user.name,
        )
        .get()
        .then(
          (value) => value.docs,
        );
    if (existingUserWithSameName.isNotEmpty &&
        existingUserWithSameName.first.id != user.id) {
      throw Exception(
        'user-already-exists',
      );
    }

    await _userRef.doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _userRef.doc(id).delete();
  }

  Future<UserModel> getUserById(String id) async {
    final user = await _userRef.doc(id).get();
    return UserModel.fromJson(user.data()!, user.id);
  }

  Stream<List<UserModel>> getUsers() {
    return _userRef.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((user) {
        return UserModel.fromJson(user.data(), user.id);
      }).toList();
    });
  }
}
