class OtherGraphResponse {
  final String? status;
  final String? msg;
  final List<OtherGraphData>? data;

  OtherGraphResponse({
    this.status,
    this.msg,
    this.data,
  });

  factory OtherGraphResponse.fromJson(Map<String, dynamic> json) {
    return OtherGraphResponse(
      status: json['status'] as String?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OtherGraphData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OtherGraphData {
  final String? date;
  final String? creatinine;
  final String? totalCholesterol;
  final String? bmi;
  final String? urineAlbumin;
  final String? urineProtein;
  final String? uricAcid;
  final String? ldl;
  final String? hdl;
  final String? vldl;
  final String? afterFood;
  final String? fasting;
  final String? random;
  final String? hba1c;
  final String? other;

  OtherGraphData({
    this.date,
    this.creatinine,
    this.totalCholesterol,
    this.bmi,
    this.urineAlbumin,
    this.urineProtein,
    this.uricAcid,
    this.ldl,
    this.hdl,
    this.vldl,
    this.afterFood,
    this.fasting,
    this.random,
    this.hba1c,
    this.other,
  });

  factory OtherGraphData.fromJson(Map<String, dynamic> json) {
    return OtherGraphData(
      date: json['date']?.toString(),
      creatinine: json['creatinine']?.toString(),
      totalCholesterol: json['total_cholesterol']?.toString(),
      bmi: json['bmi']?.toString(),
      urineAlbumin: json['urine_albumin']?.toString(),
      urineProtein: json['urine_protein']?.toString(),
      uricAcid: json['uric_acid']?.toString(),
      ldl: json['ldl']?.toString(),
      hdl: json['hdl']?.toString(),
      vldl: json['vldl']?.toString(),
      afterFood: json['after_food']?.toString(),
      fasting: json['fasting']?.toString(),
      random: json['random']?.toString(),
      hba1c: json['hba1c']?.toString(),
      other: json['other']?.toString(),
    );
  }
}
