import 'package:flutter/material.dart';

class Homeprovider extends ChangeNotifier {
  List<Icon> icon = [
    Icon(Icons.add, color: Colors.white),
    Icon(Icons.arrow_forward, color: Colors.white),
    Icon(Icons.wallet, color: Colors.white),
  ];
  List<String> soz = ["To'ldirish", "O'tkazish", "To'lash"];

 List<IconData> icons = [
  Icons.history,            
  Icons.description_outlined, 
  Icons.help_outline,     
  Icons.sell_outlined,     
  Icons.lock_reset,        
  Icons.credit_card_off, 
];
  List<String> sozs = [
    "Tranziyaksiya tarixi",
    "Malumotnoma",
    "Savollar",
    "Tariflar",
    "Pin kodni o'zgartirish",
        "Kartani yopish",
  ];



  // 1. Ikonkalar (Icons.add - Kirim / Icons.remove - Chiqim)
List<IconData> iconlar = [
  Icons.add,      // 1. Oylik maosh
  Icons.remove,   // 2. Korzinka supermarketi
  Icons.remove,   // 3. Yandex Go taksi
  Icons.remove,   // 4. Kofe va shirinlik
  Icons.add,      // 5. P2P o'tkazma (pul tushdi)
  Icons.remove,   // 6. Evos tushlik
  Icons.remove,   // 7. Beeline aloqa to'lovi
  Icons.remove,   // 8. Uztelecom internet
  Icons.remove,   // 9. Kartadan kartaga o'tkazma
  Icons.add,      // 10. Frilans loyiha to'lovi
  Icons.remove,   // 11. Dorixona (Apteka)
  Icons.remove,   // 12. Kommunal (Gaz)
  Icons.remove,   // 13. Kommunal (Elektr)
  Icons.remove,   // 14. Texnomart xaridi
  Icons.remove,   // 15. Avtomobilga yoqilg'i (Zapravka)
  Icons.add,      // 16. Qarz qaytarildi
  Icons.remove,   // 17. Sportzal obunasi
  Icons.remove,   // 18. Kinoteatr chiptasi
  Icons.remove,   // 19. Kitob xaridi
  Icons.add,      // 20. Keshbek (Cashback)
];

// 2. Qayerga / Qayerdan
List<String> sozlar = [
  "Oylik maosh",
  "Korzinka supermarketi",
  "Yandex Go taksi",
  "Kofe va shirinlik",
  "P2P o'tkazma (Ali)",
  "Evos fast-food",
  "Beeline aloqa to'lovi",
  "Uztelecom internet",
  "O'tkazma (Vali)",
  "Frilans loyiha to'lovi",
  "Dorixona (Apteka)",
  "Kommunal (Gaz)",
  "Kommunal (Elektr)",
  "Texnomart xaridi",
  "Zapravka (Ungaz)",
  "Qarz qaytarildi",
  "Sportzal obunasi",
  "Kinoteatr chiptasi",
  "Kitob xaridi (Book.uz)",
  "Oylik Keshbek",
];

// 3. Summalar (So'mda)
List<int> summas = [
  6500000,
  245000,
  28000,
  45000,
  150000,
  68000,
  50000,
  120000,
  300000,
  1200000,
  85000,
  42000,
  95000,
  450000,
  220000,
  500000,
  350000,
  60000,
  110000,
  38000,
];

// 4. Vaqti (Soat)
List<String> soats = [
  "09:00",
  "09:45",
  "10:15",
  "11:30",
  "12:00",
  "13:10",
  "14:05",
  "14:30",
  "15:15",
  "16:00",
  "16:45",
  "17:20",
  "17:25",
  "18:10",
  "18:50",
  "19:30",
  "20:00",
  "20:45",
  "21:15",
  "22:00",
];
}
