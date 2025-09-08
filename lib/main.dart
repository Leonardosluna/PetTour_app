import 'package:flutter/material.dart';
import 'pages/home_screen.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetTour',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      //Localização
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Define o português do Brasil como língua suportada
      ],
      locale: const Locale('pt', 'BR'), // Define o português do Brasil como a língua padrão
      

      home: const HomeScreen(),
    );
  }
}