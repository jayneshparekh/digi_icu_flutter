class LastSymptomsResponse {
  final String status;
  final String msg;
  final LastSymptomsData? data;

  LastSymptomsResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory LastSymptomsResponse.fromJson(Map<String, dynamic> json) {
    return LastSymptomsResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null ? LastSymptomsData.fromJson(json['data']) : null,
    );
  }
}

class LastSymptomsData {
  final String? height;
  final String? sitRightSys;
  final String? sitRightDiast;
  final String? sitRightHeartRate;
  final String? weight;
  final String? bpSys;
  final String? bpDiast;
  final String? bpHeartRate;
  final String? checkSugarNow;
  final String? fastingBsl;
  final String? afterFoodBsl;
  final String? randomBsl;
  final String? ecg;
  final String? ecgPdf;
  final String? ecgImage1;
  final String? ecgImage2;
  final String? ecgImage3;
  final String? ecgImage4;
  final String? ecgImage5;
  final String? hba1cInfo;
  final String? hba1c;
  final String? hba1cDate;
  final String? urineAlbuminInfo;
  final String? urineAlbumin;
  final String? urineAlbuminReport;

  LastSymptomsData({
    this.height,
    this.sitRightSys,
    this.sitRightDiast,
    this.sitRightHeartRate,
    this.weight,
    this.bpSys,
    this.bpDiast,
    this.bpHeartRate,
    this.checkSugarNow,
    this.fastingBsl,
    this.afterFoodBsl,
    this.randomBsl,
    this.ecg,
    this.ecgPdf,
    this.ecgImage1,
    this.ecgImage2,
    this.ecgImage3,
    this.ecgImage4,
    this.ecgImage5,
    this.hba1cInfo,
    this.hba1c,
    this.hba1cDate,
    this.urineAlbuminInfo,
    this.urineAlbumin,
    this.urineAlbuminReport,
  });

  factory LastSymptomsData.fromJson(Map<String, dynamic> json) {
    return LastSymptomsData(
      height: json['height']?.toString(),
      sitRightSys: json['sit_right_sys']?.toString(),
      sitRightDiast: json['sit_right_diast']?.toString(),
      sitRightHeartRate: json['sit_right_heart_rate']?.toString(),
      weight: json['weight']?.toString(),
      bpSys: json['bp_sys']?.toString(),
      bpDiast: json['bp_diast']?.toString(),
      bpHeartRate: json['bp_heart_rate']?.toString(),
      checkSugarNow: json['check_sugar_now']?.toString(),
      fastingBsl: json['fasting_bsl']?.toString(),
      afterFoodBsl: json['after_food_bsl']?.toString(),
      randomBsl: json['random_bsl']?.toString(),
      ecg: json['ecg']?.toString(),
      ecgPdf: json['ecg_pdf']?.toString(),
      ecgImage1: json['ecg_image_1']?.toString(),
      ecgImage2: json['ecg_image_2']?.toString(),
      ecgImage3: json['ecg_image_3']?.toString(),
      ecgImage4: json['ecg_image_4']?.toString(),
      ecgImage5: json['ecg_image_5']?.toString(),
      hba1cInfo: json['hba1c_info']?.toString(),
      hba1c: json['hba1c']?.toString(),
      hba1cDate: json['hba1c_date']?.toString(),
      urineAlbuminInfo: json['urine_albumin_info']?.toString(),
      urineAlbumin: json['urine_albumin']?.toString(),
      urineAlbuminReport: json['urine_albumin_report']?.toString(),
    );
  }
}

