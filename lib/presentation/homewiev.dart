import 'package:bank_card/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart' hide CardType;

class Homewiev extends StatelessWidget {
  const Homewiev({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HomeRepository.getcard(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          print(snap.error);
          return Center(child: Text(snap.error.toString()));
        } else {
          return SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, index) {
                final card = snap.data?[index];
                return CreditCardUi(
                //  showBalance: true,                                
                //  balance: 12000,
                  creditCardType: CreditCardType.visa,
                  cardHolderFullName: card?.holdername ?? "Unknown",
                  cardNumber: card?.cardnumber.toString() ?? "Unknown",
                  validThru: card?.expireData.toString() ?? "Unknown",
                );
              },
            ),
          );
        }
      },
    );
  }
}
