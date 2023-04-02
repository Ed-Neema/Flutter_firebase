import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:freelancer_firebase/firebase_options.dart';
import 'package:freelancer_firebase/screens/home_page.dart';
import 'package:freelancer_firebase/screens/login_screen.dart';
import 'package:freelancer_firebase/screens/register_screen.dart';
import 'package:freelancer_firebase/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          builder: ((context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return HomePage(user: snapshot.data);
            }
            return LoginScreen();
          }),
          stream: AuthService().firebaseAuth.authStateChanges()),
    );
  }
}
