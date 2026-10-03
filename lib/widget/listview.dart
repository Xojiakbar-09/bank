import 'package:flutter/material.dart';

class Listviewcustom extends StatelessWidget {
  final IconData icon;
  final String soz;
  final VoidCallback ontap;
  const Listviewcustom({
    super.key,
    required this.icon,
    required this.soz,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        
        onTap: ontap,
        title: Text(soz),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade900,
          ),
          child: Icon(icon),
        ),
        trailing: Icon((Icons.arrow_forward_ios)),
      ),
    );
  }
}
