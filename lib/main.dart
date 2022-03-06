import 'package:flutter/material.dart';
import 'package:whatsappweb/rotas.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: PaletaCores.corPrimaria,
  appBarTheme: const AppBarTheme(backgroundColor: PaletaCores.corPrimaria),
  //accentColor: PaletaCores.corDestaque,
);

//documentação: https://firebase.flutter.dev/docs/overview/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: "WhatsApp Web",
    debugShowCheckedModeBanner: false,
    //home: Login(),
    theme: temaPadrao,
    initialRoute: "/", onGenerateRoute: Rotas.gerarRota,
  ));
}
