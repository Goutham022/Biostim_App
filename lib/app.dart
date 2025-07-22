import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/connection_provider.dart';
import 'screens/home_screen.dart';

class BiostepApp extends StatelessWidget {
  const BiostepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
      ],
      child: MaterialApp(
        title: 'Biostep Companion',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const HomeScreen(),
      ),
    );
  }
} 