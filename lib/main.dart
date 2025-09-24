import 'package:dog_breeds_app/screens/breed_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/breeds_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BreedsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cat Breeds App",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
      routes: {
        "/breed-detail": (ctx) => const BreedDetailScreen(),
      },
    );
  }
}
