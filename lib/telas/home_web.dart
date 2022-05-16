import 'package:flutter/material.dart';
import 'package:whatsappweb/uteis/paleta_cores.dart';
import 'package:whatsappweb/uteis/responsivo.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;
    final isWeb = Responsivo.isWeb(context);

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              color: PaletaCores.corPrimaria,
              width: largura,
              height: altura * 0.2,
            )),
            Positioned(
                top: isWeb ? altura * 0.05 : 0,
                bottom: isWeb ? altura * 0.05 : 0,
                left: isWeb ? largura * 0.05 : 0,
                right: isWeb ? largura * 0.05 : 0,
                child: Row(
                  children: const [
                    Expanded(
                      flex: 4,
                      child: AreaLateralConversas(),
                    ),
                    Expanded(
                      flex: 10,
                      child: AreaLateralMensagens(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class AreaLateralConversas extends StatelessWidget {
  const AreaLateralConversas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.orange,
    );
  }
}

class AreaLateralMensagens extends StatelessWidget {
  const AreaLateralMensagens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.purple,
    );
  }
}
