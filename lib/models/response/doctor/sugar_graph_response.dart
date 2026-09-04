class SugarGraphResponse {
  final String? status;
  final String? msg;
  final List<SugarGraphData>? data;

  SugarGraphResponse({
    this.status,
    this.msg,
    this.data,
  });

  factory SugarGraphResponse.fromJson(Map<String, dynamic> json) {
    return SugarGraphResponse(
      status: json['status'] as String?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SugarGraphData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SugarGraphData {
  final String fasting;
  final String afterFood;
  final String random;
  final String created;

  SugarGraphData({
    required this.fasting,
    required this.afterFood,
    required this.random,
    required this.created,
  });

  factory SugarGraphData.fromJson(Map<String, dynamic> json) {
    return SugarGraphData(
      fasting: (json['fasting'] ?? '').toString(),
      afterFood: (json['after_food'] ?? '').toString(),
      random: (json['random'] ?? '').toString(),
      created: (json['created'] ?? '').toString(),
    );
  }
}
