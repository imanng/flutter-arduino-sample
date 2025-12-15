class ReceivedDataModel {
  final int ledStatus;

  ReceivedDataModel({
    required this.ledStatus,
  });

  factory ReceivedDataModel.fromJson(Map<String, dynamic> json) {
    return ReceivedDataModel(
      ledStatus: json['ledStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledStatus': ledStatus,
    };
  }
}

class SendDataModel {
  final String ledStatus;

  SendDataModel({required this.ledStatus});

  Map<String, dynamic> toJson() {
    return {
      'ledStatus': ledStatus,
    };
  }
}
