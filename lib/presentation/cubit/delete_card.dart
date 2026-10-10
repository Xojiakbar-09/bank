import 'package:bank_card/repository/card.dart';

enum CardsStatus { initial, loading, success, failure }

class CardsState {
  final CardsStatus status;
  final List<CardModel> cards;
  final String? errorMessage;

  CardsState({
    this.status = CardsStatus.initial,
    this.cards = const [],
    this.errorMessage,
  });

  CardsState copyWith({
    CardsStatus? status,
    List<CardModel>? cards,
    String? errorMessage,
  }) {
    return CardsState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      errorMessage: errorMessage,
    );
  }
}