import 'package:flutter/material.dart';

class Listtial extends StatelessWidget {
  final IconData icon;
  final String soz;
  final int summa;
  final String soat;
  const Listtial({
    super.key,
    required this.icon,
    required this.soz,
    required this.summa,
    required this.soat,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(soz),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade900
        ),
        padding: EdgeInsets.all(8),
         child: Icon(icon)),
      subtitle: Text("${summa.toString()} so'm", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),),
      trailing: Text(soat),
    );
  }
}
