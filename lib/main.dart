import 'package:flutter/material.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/screens/screen_splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ApiService.create(),
      dispose: (_, ApiService service) => service.client.dispose(),
      child: MaterialApp(
        title: 'Hey Voltz',
        theme: ThemeData.light(),
        home: SplashScreen(),
      ),
    );
  }
}
