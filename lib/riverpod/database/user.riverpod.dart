import 'package:ucpc_inventory_management_app/exports.dart';

final getUserFutureProvider = FutureProvider.family<UserModel, String>((
  ref,
  id,
) async {
  return await UserDatabase.instance.getUserById(id);
});

final getUsersStreamProvider = StreamProvider<List<UserModel>>(
  (ref) => UserDatabase.instance.getUsers(),
);

final userSearchQueryProvider = StateProvider<String>((ref) => '');
