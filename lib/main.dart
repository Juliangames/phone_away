import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phone_away/core/router/router.dart'; // Importiere deine neue Router-Datei
import 'package:phone_away/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

import 'firebase_options.dart';

// 🔔 Create the global instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase initialization
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
      name: 'phone_away',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // ✅ Notification initialization
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          // Update system brightness if theme option is system
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final brightness = MediaQuery.platformBrightnessOf(context);
            themeManager.updateSystemBrightness(brightness == Brightness.dark);
          });

          return MaterialApp.router(
            // Hier verwenden wir MaterialApp.router
            debugShowCheckedModeBanner: false,
            title: 'PhoneAway',
            theme: themeManager.lightTheme,
            darkTheme: themeManager.darkTheme,
            themeMode: themeManager.themeMode,
            routerConfig: appRouter, // Die GoRouter-Instanz übergeben
          );
        },
      ),
    );
  }
}
