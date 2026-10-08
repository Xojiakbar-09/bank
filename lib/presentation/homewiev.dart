import 'package:bank_card/repository/card.dart';
import 'package:bank_card/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart' hide CardType;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Future'ni faqat bir marta e'lon qilamiz
  late final Future<List<CardModel>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _cardsFuture = HomeRepository.getCards();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CardModel>>(
      future: _cardsFuture, // initState'da yaratilgan future beriladi
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          return Center(
            child: Text(
              "Xatolik yuz berdi: ${snap.error}",
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snap.hasData || snap.data!.isEmpty) {
          return const Center(child: Text("Kartalar topilmadi"));
        }

        final cards = snap.data!;

        return SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];

              return CreditCardUi(
                creditCardType: CreditCardType.visa,
                cardHolderFullName: card.holdername,
                cardNumber: card.cardnumber.toString(),
                validThru: card.expireData.toString(),
              );
            },
          ),
        );
      },
    );
  }
}