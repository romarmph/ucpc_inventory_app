import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('UCPC Inventory'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1 / 1,
                ),
                children: const [
                  MainMenuButtonCard(
                    title: 'Inventory',
                    icon: Icons.inventory_rounded,
                    route: Routes.inventory,
                  ),
                  MainMenuButtonCard(
                    title: 'Suppliers',
                    icon: Icons.business_center_rounded,
                    route: Routes.suppliers,
                  ),
                  MainMenuButtonCard(
                    title: 'Orders',
                    icon: Icons.shopping_cart_rounded,
                    route: Routes.orders,
                  ),
                  MainMenuButtonCard(
                    title: 'Users',
                    icon: Icons.admin_panel_settings_rounded,
                    route: Routes.users,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          width: deviceWidth * 0.8,
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
      endDrawer: SafeArea(
        child: Drawer(
          width: deviceWidth * 0.8,
        ),
      ),
    );
  }
}
