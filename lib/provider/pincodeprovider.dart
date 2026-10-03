import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PinProvider extends ChangeNotifier {
  final box = GetStorage();

  String currentPin = ""; 
  String tempPin = ""; 

  bool isFirstTime = true; 
  bool isConfirmingStep = false; 
  String titleText = ""; 

  PinProvider() {
    checkUserStatus();
  }

  void checkUserStatus() {
    bool? hasEntered = box.read('kirdi');

    if (hasEntered == true) {
      isFirstTime = false;
      titleText = "PIN-kodni kiriting";
    } else {
      isFirstTime = true;
      titleText = "Yangi PIN-kod kiriting";
    }
    notifyListeners();
  }

  // Raqam bosilganda
  void onNumberTap(
    String number,
    Function(String text, bool isError) showSnackBar,
    VoidCallback onSuccess,
  ) {
    if (currentPin.length < 4) {
      currentPin += number;
      notifyListeners();

      // 4 ta raqam bo'lganda ishlaydi
      if (currentPin.length == 4) {
        // UI qotib qolmasligi va state to'qnashuvi bo'lmasligi uchun biroz kutib keyin bajarish tavsiya etiladi
        Future.delayed(const Duration(milliseconds: 100), () {
          handlePinLogic(showSnackBar, onSuccess);
        });
      }
    }
  }

  void onDeleteTap() {
    if (currentPin.isNotEmpty) {
      currentPin = currentPin.substring(0, currentPin.length - 1);
      notifyListeners();
    }
  }

  Future<void> handlePinLogic(
    Function(String text, bool isError) showSnackBar,
    VoidCallback onSuccess,
  ) async {
    if (isFirstTime) {
      if (!isConfirmingStep) {
        // 1-qadam: Yangi PIN yozildi, uni vaqtincha saqlaymiz
        tempPin = currentPin;
        currentPin = "";
        isConfirmingStep = true;
        titleText = "PIN-kodni tasdiqlang";
        notifyListeners();
      } else {
        // 2-qadam: Tasdiqlash uchun kiritilgan PIN solishtiriladi
        if (currentPin == tempPin) {
          await box.write('kirdi', true);
          await box.write('pin_code', currentPin);
          
          showSnackBar("PIN-kod muvaffaqiyatli o'rnatildi!", false);
          onSuccess(); 
        } else {
          showSnackBar("PIN-kodlar mos kelmadi, qaytadan urinib ko'ring!", true);
          resetFirstTime();
        }
      }
    } else {
      // Kirish qadami
      String? savedPin = box.read('pin_code');

      if (currentPin == savedPin) {
        onSuccess(); 
      } else {
        showSnackBar("PIN-kod noto'g'ri kiritildi!", true);
        currentPin = "";
        notifyListeners();
      }
    }
  }

  void resetFirstTime() {
    currentPin = "";
    tempPin = "";
    isConfirmingStep = false;
    titleText = "Yangi PIN-kod kiriting";
    notifyListeners();
  }
}