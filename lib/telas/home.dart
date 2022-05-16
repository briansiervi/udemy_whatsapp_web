import 'package:flutter/material.dart';
import 'package:whatsappweb/uteis/responsivo.dart';

import 'home_mobile.dart';
import 'home_web.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsivo(
        mobile: HomeMobile(), tablet: HomeWeb(), web: HomeWeb());
  }
}
