import 'package:bank_card/presentation/cubit/add_card_stet.dart';
import 'package:bank_card/repository/home_add_card_repository.dart'; // Repository faylingiz yo'li
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(const AddCardState());

  Future<void> addCard({
    required String name,
    required String cardNumber,
    required String cvv,
  }) async {
    // 1. Formani tekshirish
    final cleanCardNumber = cardNumber.replaceAll(' ', '');

    if (name.trim().isEmpty || cleanCardNumber.length < 16 || cvv.length < 3) {
      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: "Iltimos, barcha maydonlarni to'g'ri to'ldiring!",
      ));
      return;
    }

    emit(state.copyWith(status: AddCardStatus.loading));

    try {
  await HomeAddCardRepository.creatNewCard(
  name: name.trim(),
  cardNumber: cleanCardNumber,
  cvv: int.parse(cvv),
  mudatti: DateTime.now(), // Yoki tanlangan sana
);
      // Muvaffaqiyatli saqlandi
      emit(state.copyWith(status: AddCardStatus.success));
    } catch (e) {
      // API yoki tarmoq xatoligi yuz berganda
      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: "Karta qo'shishda xatolik yuz berdi!",
      ));
    }
  }
}