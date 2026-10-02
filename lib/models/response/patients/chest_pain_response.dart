class ChestPainResponse {
  final String status;
  final String msg;
  final int chestPainId;
  final int score;

  ChestPainResponse({
    required this.status,
    required this.msg,
    this.chestPainId = 0,
    this.score = 0,
  });

  factory ChestPainResponse.fromJson(Map<String, dynamic> json) {
    int parsedChestPainId = 0;
    if (json['chest_pain_id'] != null) {
      parsedChestPainId = int.tryParse(json['chest_pain_id'].toString()) ?? 0;
    }

    int parsedScore = 0;
    if (json['score'] != null) {
      parsedScore = int.tryParse(json['score'].toString()) ?? 0;
    }

    return ChestPainResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      chestPainId: parsedChestPainId,
      score: parsedScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'chest_pain_id': chestPainId,
      'score': score,
    };
  }
}
