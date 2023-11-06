import 'package:ucpc_inventory_management_app/exports.dart';

final getUserByIdStream = StreamProvider.family<UserModel, String>((
  ref,
  id,
) {
  return UserDatabase.instance.getUserById(id);
});

final getUsersStreamProvider = StreamProvider<List<UserModel>>(
  (ref) => UserDatabase.instance.getUsers(),
);

final userSearchQueryProvider = StateProvider<String>((ref) => '');
