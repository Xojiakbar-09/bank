import 'package:bank_card/presentation/cubit/delete_card.dart';
import 'package:bank_card/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsCubit extends Cubit<CardsState> {
  CardsCubit() : super(CardsState());

  Future<void> fetchCards() async {
    emit(state.copyWith(status: CardsStatus.loading));
    try {
      final cards = await HomeRepository.getCards();
      emit(state.copyWith(status: CardsStatus.success, cards: cards));
    } catch (e) {
      emit(state.copyWith(status: CardsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> deleteCard(String cardId) async {
    final previousCards = state.cards;
    
    final updatedCards = previousCards.where((card) => card.cardnumber != cardId).toList();
    emit(state.copyWith(cards: updatedCards));

    try {
      await HomeRepository.deleteCard(cardId);
    } catch (e) {
      emit(state.copyWith(
        cards: previousCards,
        status: CardsStatus.failure,
        errorMessage: "Kartani o'chirish amalga oshmadi: $e",
      ));
    }
  }
}