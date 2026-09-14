class AddQuickFormReq {
  final String patientId;
  final String formId;
  final String bpSystolic;
  final String bpDiastolic;
  final String sittingBpSystolic;
  final String sittingBpDiastolic;
  final String standingBpSystolic;
  final String standingBpDiastolic;
  final String fasting;
  final String afterFood;
  final String random;
  final String weight;
  final String episode;
  final String hospitalization;
  final String tmtResult;
  final String mets;
  final String others;
  final String creatinine;
  final String hba1c;
  final String hba1cDate;
  final String totalCholesterol;
  final String otherInvestigation;
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

  AddQuickFormReq({
    required this.patientId,
    this.formId = '',
    this.bpSystolic = '',
    this.bpDiastolic = '',
    this.sittingBpSystolic = '',
    this.sittingBpDiastolic = '',
    this.standingBpSystolic = '',
    this.standingBpDiastolic = '',
    this.fasting = '',
    this.afterFood = '',
    this.random = '',
    this.weight = '',
    this.episode = '',
    this.hospitalization = '',
    this.tmtResult = '',
    this.mets = '',
    this.others = '',
    this.creatinine = '',
    this.hba1c = '',
    this.hba1cDate = '',
    this.totalCholesterol = '',
    this.otherInvestigation = '',
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'patient_id': patientId,
      'bp_systolic': bpSystolic,
      'bp_diastolic': bpDiastolic,
      'sitting_bp_systolic': sittingBpSystolic,
      'sitting_bp_diastolic': sittingBpDiastolic,
      'standing_bp_systolic': standingBpSystolic,
      'standing_bp_diastolic': standingBpDiastolic,
      'fasting': fasting,
      'after_food': afterFood,
      'random': random,
      'weight': weight,
      'episode': episode,
      'hospitalization': hospitalization,
      'tmt_result': tmtResult,
      'mets': mets,
      'others': others,
      'creatinine': creatinine,
      'hba1c': hba1c,
      'hba1c_date': hba1cDate,
      'total_cholesterol': totalCholesterol,
      'other_investigation': otherInvestigation,
      'my_bsl': myBsl,
      'morning_fasting': morningFasting,
      'morning_medicine': morningMedicine,
      'morning_med_name': morningMedName,
      'post_lunch': postLunch,
      'lunch_medicine': lunchMedicine,
      'lunch_med_name': lunchMedName,
      'night': night,
      'night_medicine': nightMedicine,
      'night_med_name': nightMedName,
      'coa': coa,
      'ras': ras,
      'rwma': rwma,
      'rwma_details': rwmaDetails,
      'lvh': lvh,
      'lvidd': lvidd,
      'lvpwd': lvpwd,
      'ef': ef,
      'eoa1': eoa1,
      'eoa2': eoa2,
      'lvdd': lvdd,
      'rv_dysfunction': rvDysfunction,
      'pah': pah,
      'pasp': pasp,
      'regularization': regularization,
      'regularization_details': regularizationDetails,
      'echo_other_details': echoOtherDetails,
    };
    if (formId.isNotEmpty) {
      map['form_id'] = formId;
    }
    return map;
  }
}
