class QuickFormDetailResponse {
  final String status;
  final String msg;
  final QuickFormData? data;

  QuickFormDetailResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory QuickFormDetailResponse.fromJson(Map<String, dynamic> json) {
    QuickFormData? formData;
    if (json['data'] != null && json['data'] is Map) {
      formData = QuickFormData.fromJson(Map<String, dynamic>.from(json['data'] as Map));
    }
    return QuickFormDetailResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: formData,
    );
  }
}

class QuickFormData {
  final String patientId;
  final String bpSystolic;
  final String bpDiastolic;
  final String sittingBpSystolic;
  final String sittingBpDiastolic;
  final String standingBpSystolic;
  final String standingBpDiastolic;
  final String creatinine;
  final String hba1c;
  final String totalCholesterol;
  final String otherInvestigation;
  final String haveSugar;
  final String sugarLevel;
  final String fasting;
  final String afterFood;
  final String random;
  final String weight;
  final String myBsl;
  final String morningFasting;
  final String morningMedicine;
  final String morningMedName;
  final String postLunch;
  final String lunchMedicine;
  final String lunchMedName;
  final String night;
  final String nightMedicine;
  final String nightMedName;
  final String episode;
  final String hospitalizeReason;
  final String sugarTest;
  final String hospitalization;
  final String tmtResult;
  final String mets;
  final String others;
  final String hba1cDate;

  final String coa;
  final String ras;
  final String rwma;
  final String rwmaDetails;
  final String lvh;
  final String lvidd;
  final String lvpwd;
  final String ef;
  final String eoa1;
  final String eoa2;
  final String lvdd;
  final String rvDysfunction;
  final String pah;
  final String pasp;
  final String regularization;
  final String regularizationDetails;
  final String echoOtherDetails;

  QuickFormData({
    this.patientId = '',
    this.bpSystolic = '',
    this.bpDiastolic = '',
    this.sittingBpSystolic = '',
    this.sittingBpDiastolic = '',
    this.standingBpSystolic = '',
    this.standingBpDiastolic = '',
    this.creatinine = '',
    this.hba1c = '',
    this.totalCholesterol = '',
    this.otherInvestigation = '',
    this.haveSugar = '',
    this.sugarLevel = '',
    this.fasting = '',
    this.afterFood = '',
    this.random = '',
    this.weight = '',
    this.myBsl = '',
    this.morningFasting = '',
    this.morningMedicine = '',
    this.morningMedName = '',
    this.postLunch = '',
    this.lunchMedicine = '',
    this.lunchMedName = '',
    this.night = '',
    this.nightMedicine = '',
    this.nightMedName = '',
    this.episode = '',
    this.hospitalizeReason = '',
    this.sugarTest = '',
    this.hospitalization = '',
    this.tmtResult = '',
    this.mets = '',
    this.others = '',
    this.hba1cDate = '',
    this.coa = '',
    this.ras = '',
    this.rwma = '',
    this.rwmaDetails = '',
    this.lvh = '',
    this.lvidd = '',
    this.lvpwd = '',
    this.ef = '',
    this.eoa1 = '',
    this.eoa2 = '',
    this.lvdd = '',
    this.rvDysfunction = '',
    this.pah = '',
    this.pasp = '',
    this.regularization = '',
    this.regularizationDetails = '',
    this.echoOtherDetails = '',
  });

  factory QuickFormData.fromJson(Map<String, dynamic> json) {
    return QuickFormData(
      patientId: json['patient_id']?.toString() ?? '',
      bpSystolic: json['bp_systolic']?.toString() ?? '',
      bpDiastolic: json['bp_diastolic']?.toString() ?? '',
      sittingBpSystolic: json['sitting_bp_systolic']?.toString() ?? '',
      sittingBpDiastolic: json['sitting_bp_diastolic']?.toString() ?? '',
      standingBpSystolic: json['standing_bp_systolic']?.toString() ?? '',
      standingBpDiastolic: json['standing_bp_diastolic']?.toString() ?? '',
      creatinine: json['creatinine']?.toString() ?? '',
      hba1c: json['hba1c']?.toString() ?? '',
      totalCholesterol: json['total_cholesterol']?.toString() ?? '',
      otherInvestigation: json['other_investigation']?.toString() ?? '',
      haveSugar: json['have_sugar']?.toString() ?? '',
      sugarLevel: json['sugar_level']?.toString() ?? '',
      fasting: json['fasting']?.toString() ?? '',
      afterFood: json['after_food']?.toString() ?? '',
      random: json['random']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      myBsl: json['my_bsl']?.toString() ?? '',
      morningFasting: json['morning_fasting']?.toString() ?? '',
      morningMedicine: json['morning_medicine']?.toString() ?? '',
      morningMedName: json['morning_med_name']?.toString() ?? '',
      postLunch: json['post_lunch']?.toString() ?? '',
      lunchMedicine: json['lunch_medicine']?.toString() ?? '',
      lunchMedName: json['lunch_med_name']?.toString() ?? '',
      night: json['night']?.toString() ?? '',
      nightMedicine: json['night_medicine']?.toString() ?? '',
      nightMedName: json['night_med_name']?.toString() ?? '',
      episode: json['episode']?.toString() ?? '',
      hospitalizeReason: json['hospitalize_reason']?.toString() ?? '',
      sugarTest: json['sugar_test']?.toString() ?? '',
      hospitalization: json['hospitalization']?.toString() ?? '',
      tmtResult: json['tmt_result']?.toString() ?? '',
      mets: json['mets']?.toString() ?? '',
      others: json['others']?.toString() ?? '',
      hba1cDate: json['hba1c_date']?.toString() ?? '',
      coa: json['coa']?.toString() ?? '',
      ras: json['ras']?.toString() ?? '',
      rwma: json['rwma']?.toString() ?? '',
      rwmaDetails: json['rwma_details']?.toString() ?? '',
      lvh: json['lvh']?.toString() ?? '',
      lvidd: json['lvidd']?.toString() ?? '',
      lvpwd: json['lvpwd']?.toString() ?? '',
      ef: json['ef']?.toString() ?? '',
      eoa1: json['eoa1']?.toString() ?? '',
      eoa2: json['eoa2']?.toString() ?? '',
      lvdd: json['lvdd']?.toString() ?? '',
      rvDysfunction: json['rv_dysfunction']?.toString() ?? '',
      pah: json['pah']?.toString() ?? '',
      pasp: json['pasp']?.toString() ?? '',
      regularization: json['regularization']?.toString() ?? '',
      regularizationDetails: json['regularization_details']?.toString() ?? '',
      echoOtherDetails: json['echo_other_details']?.toString() ?? '',
    );
  }
}
