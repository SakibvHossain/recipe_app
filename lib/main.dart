import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/provider/favorite_button_provider.dart';
import 'package:recipe_app/provider/quantity.dart';
import 'package:recipe_app/views/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => QuantityProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppMainScreen(),
      ),
    );
  }
}

