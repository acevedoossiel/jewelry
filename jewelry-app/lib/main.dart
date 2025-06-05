import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jewelry_app/providers/jewelry_providers.dart';
import 'package:jewelry_app/screens/favorites_screen.dart';
import 'package:jewelry_app/screens/home_screen.dart';
import 'package:jewelry_app/providers/cart_provider.dart';
import 'package:jewelry_app/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JewelryProviders()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Joyería LunA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.pink.shade400,
            secondary: Colors.pink.shade100,
            tertiary: Colors.purple.shade100,
          ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'QuickSand'),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.pinkAccent,
            foregroundColor: Colors.white,
            elevation: 2,
            titleTextStyle: TextStyle(
              fontFamily: 'Satisfy',
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.pink.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.pinkAccent),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const InitialScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const JewelryStore(),
        },
      ),
    );
  }
}

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
                    // Navegar o mostrar modal para agregar producto
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.pinkAccent,
                )
                : null,
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserSession();

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

// -----------------------------
// PANTALLA DE LOGIN
// -----------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      // Ahora sí, sesión guardada correctamente
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        errorMessage = 'Credenciales inválidas';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text("Iniciar sesión"),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: colors.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
