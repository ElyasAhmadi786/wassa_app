import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "code4fun-40c9c",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
      databaseURL: "https://code4fun-40c9c-default-rtdb.asia-southeast1.firebasedatabase.app/",
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: SplashScreen(),
    );
  }
}

class RealtimeDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>> fetchData(String path) async {
    try {
      DataSnapshot snapshot = await _dbRef.child(path).get();
      if (snapshot.value != null) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        throw Exception("No data available at path: $path");
      }
    } catch (error) {
      throw Exception("Error fetching data: $error");
    }
  }
}
