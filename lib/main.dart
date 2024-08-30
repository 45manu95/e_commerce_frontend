import 'package:e_commerce_frontend/models/access/access.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/user_client.dart';
import 'data/user_type.dart';

///creazione variabili di tema globale
var kColorScheme = const ColorScheme(
  primary: Colors.lightBlue, //colore primario
  secondary: Colors.white, // Colore di sfondo
  surface: Colors.white, // Colore delle superfici
  error: Colors.red, // Colore per gli errori
  onPrimary: Colors.black, // Colore del testo su sfondo primario
  onSecondary: Colors.white, // Colore del testo su sfondo
  onSurface: Colors.black, // Colore del testo sulle superfici
  onError: Colors.white,
  brightness: Brightness.light,
);

void main() {
  runApp(const MyApp());
}

///variabile globale utente
User userData = User();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme:
            ThemeData(colorScheme: kColorScheme).copyWith(),
        home: const Access(),
      ),
    );
  }
}

