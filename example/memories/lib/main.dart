import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/cloudinary_config.dart';
import 'screens/home_screen.dart';
import 'services/cloudinary_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  CloudinaryService().initialize(
    cloudName: CloudinaryConfig.cloudName,
    uploadPreset: CloudinaryConfig.uploadPreset,
    apiKey: CloudinaryConfig.apiKey,
    apiSecret: CloudinaryConfig.apiSecret,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 3,
          shape: CircleBorder(),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
