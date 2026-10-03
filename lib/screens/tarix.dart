import 'package:bank_card/provider/homeprovider.dart';
import 'package:bank_card/widget/listtial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tarix extends StatelessWidget {
  const Tarix({super.key});
  @override
  Widget build(BuildContext context) {
     final home = context.watch<Homeprovider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Tranziyaksiya tarixi"),
        actionsPadding: EdgeInsets.only(right: 5),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.tune))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: home.iconlar.length,
              itemBuilder: (context, index) {
                return Listtial(icon: home.iconlar[index] , soz: home.sozlar[index], summa: home.summas[index], soat: home.soats[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
