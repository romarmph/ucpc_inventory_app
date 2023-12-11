import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';
import 'package:ucpc_inventory_management_app/riverpod/database/user.riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final currentUser = ref.watch(authProvider).currentUser.uid;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('UCPC Inventory'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications_rounded),
        //     onPressed: () {
        //       _scaffoldKey.currentState!.openEndDrawer();
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ref.watch(getUserByIdStream(currentUser)).when(
                  data: (user) {
                    return Expanded(
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          childAspectRatio: 2 / 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        children: [
                          const MainMenuButtonCard(
                            title: 'Inventory',
                            icon: Icons.inventory_rounded,
                            route: Routes.inventory,
                          ),
                          // const MainMenuButtonCard(
                          //   title: 'Suppliers',
                          //   icon: Icons.business_center_rounded,
                          //   route: Routes.suppliers,
                          // ),
                          // const MainMenuButtonCard(
                          //   title: 'Orders',
                          //   icon: Icons.shopping_cart_rounded,
                          //   route: Routes.orders,
                          // ),
                          Visibility(
                            visible: user.role == UserRoles.admin,
                            child: const MainMenuButtonCard(
                              title: 'Users',
                              icon: Icons.admin_panel_settings_rounded,
                              route: Routes.users,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return const Center(
                      child: Text('Error'),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          ],
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          width: deviceWidth > 500 ? 300 : deviceWidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    ref.read(authProvider).signOut();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      // endDrawer: SafeArea(
      //   child: Drawer(
      //     width: deviceWidth > 500 ? 300 : deviceWidth * 0.8,
      //   ),
      // ),
    );
  }
}
