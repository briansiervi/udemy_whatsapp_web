import 'package:flutter/material.dart';

class Responsivo extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const Responsivo(
      {Key? key, required this.mobile, required this.web, this.tablet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1200) {
        return web;
      } else if (constraints.maxWidth >= 800) {
        Widget? redTablet = tablet;

        if (redTablet != null) {
          return redTablet;
        } else {
          return web;
        }
      } else {
        return mobile;
      }
    });
  }
}
