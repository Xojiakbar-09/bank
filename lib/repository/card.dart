class CardModel {
  final String holdername;
  final int cvv;
  final DateTime expireData;
  final int cardnumber;
  final int documentId;

  CardModel({
    required this.documentId,
    required this.holdername,
    required this.cvv,
    required this.expireData,
    required this.cardnumber,
  });

  static CardModel fromJson(Map<String, dynamic> json) => CardModel(
        holdername: json['name']?.toString() ?? 'Unknown',
        cvv: _parseInt(json["cvv"]),
        expireData: DateTime.tryParse(json["mudatti"]?.toString() ?? '') ?? DateTime.now(),
        cardnumber: _parseInt(json["number"]),
        documentId: _parseInt(json["documentId"]),
      );

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}