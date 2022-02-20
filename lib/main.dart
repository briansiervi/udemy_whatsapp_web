import 'package:flutter/material.dart';
import 'telas/login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

//documentação: https://firebase.flutter.dev/docs/overview/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: "WhatsApp Web",
    home: Login(),
  ));
}
