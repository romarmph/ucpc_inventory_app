import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';
import 'package:ucpc_inventory_management_app/riverpod/database/user.riverpod.dart';

class UsersHomeView extends ConsumerWidget {
  const UsersHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ref.watch(getUsersStreamProvider).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final user = data[index];
                  return ListTile(
                    leading: Icon(user.role == UserRoles.admin
                        ? Icons.admin_panel_settings_rounded
                        : Icons.person_rounded),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserView(
                            user: user,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return const Center(
                child: Text(
                  'Error fetching users',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserAddForm(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
