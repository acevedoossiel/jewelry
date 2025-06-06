import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';

class JewelryStore extends StatelessWidget {
  const JewelryStore({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.user?.role == 'admin';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          title: const Text(
            "Joyería LunA",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home), text: 'Inicio'),
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
            ],
          ),
        ),
        body: const TabBarView(children: [HomeScreen(), FavoritesScreen()]),
        floatingActionButton:
            isAdmin
                ? FloatingActionButton(
                  onPressed: () {
                    // Aquí podrías navegar a agregar producto o mostrar modal
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.pinkAccent,
                )
                : null,
      ),
    );
  }
}
