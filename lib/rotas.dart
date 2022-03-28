import 'package:flutter/material.dart';
import 'package:whatsappweb/telas/home.dart';
import 'package:whatsappweb/telas/login.dart';
import 'package:whatsappweb/telas/mensagens.dart';

import 'modelos/usuario.dart';

class Rotas {
  static Route<dynamic> gerarRota(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => const Home());
      case "/mensagens":
        return MaterialPageRoute(builder: (_) => Mensagens(args as Usuario));
    }

    return _erroRota();
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
