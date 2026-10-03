import 'package:flutter/material.dart';

class Circlor extends StatelessWidget {
  final String soz;
  final Widget icon;
  const Circlor({super.key, required this.icon, required this.soz});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.purple,
          child: icon,
        ),
        SizedBox(height: 5,),
        Text(soz),
      ],
    );
  }
}
