class CardModel {
  final String holdername;
  final int cvv;
  final DateTime expireData;
  final int cardnumber;
  final String documentId; 

  CardModel({
    required this.documentId,
    required this.holdername,
    required this.cvv,
    required this.expireData,
    required this.cardnumber,
  });

  static CardModel fromJson(Map<String, dynamic> json) {
    // Strapi ba'zan ma'lumotlarni 'attributes' ichida qaytaradi, tekshirib olamiz:
    final Map<String, dynamic> data = json['attributes'] ?? json;

    return CardModel(
      documentId: json["documentId"]?.toString() ?? json["id"]?.toString() ?? '',
      holdername: data['name']?.toString() ?? 'Unknown',
      cvv: _parseInt(data["cvv"]),
      expireData: DateTime.tryParse(data["mudatti"]?.toString() ?? '') ?? DateTime.now(),
      cardnumber: _parseInt(data["number"]),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}