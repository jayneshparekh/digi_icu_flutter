class ClinicalFormDetailsModel {
  String place;
  String systolic1;
  String diastolic1;
  String heartRate1;
  String height;
  String weight;
  String spo2;
  String spo2Details;
  String bmi;
  String bpApparatus;

  // Section 2 parameters
  String checkSugar;
  String fasting;
  String afterFood;
  String random;
  String creatinine;
  String totalCholesterol;
  String hdl;
  String ldl;
  String vldl;
  String hba1c;
  String hba1cDate;
  String urineAlbumin;
  String urineAlbuminReport;
  String ecg;
  String ecgPdf;
  String ecgImage1;
  String ecgImage2;
  String ecgImage3;
  String thyroid;
  String t3;
  String t4;
  String tsh;
  String uricAcid;
  String otherInvestigations;
  String investigationDetails;
  String investigations;
  String investigationImage1;
  String investigationImage2;
  String investigationImage3;

  // Section 3 parameters
  String improvement;
  String chestPain;
  String chestPainSweating;
  String breathlessness;
  String breathlessWhile;
  String palpitations;
  String giddiness;
  String headache;
  String dizziness;
  String dizzinessSystolic;
  String dizzinessDiaStolic;
  String otherSymptoms;
  String otherSymptomsDetails;
  String systolic2;
  String diastolic2;
  String heartRate2;
  String bleedingEpisode;

  // Section 4 parameters
  String smoking;
  String alcohol;
  String reduceSalt;
  String exercise;
  String inStress;
  String missMedicine;
  String lastHospitalization;
  String hospitalizationReason;
  String remindMedicine;
  String setAlarm;
  String systolic3;
  String diastolic3;
  String heartRate3;

  ClinicalFormDetailsModel({
    this.place = 'Home',
    this.systolic1 = '',
    this.diastolic1 = '',
    this.heartRate1 = '',
    this.height = '',
    this.weight = '',
    this.spo2 = '',
    this.spo2Details = '',
    this.bmi = '',
    this.bpApparatus = '',
    this.checkSugar = '',
    this.fasting = '',
    this.afterFood = '',
    this.random = '',
    this.creatinine = '',
    this.totalCholesterol = '',
    this.hdl = '',
    this.ldl = '',
    this.vldl = '',
    this.hba1c = '',
    this.hba1cDate = '',
    this.urineAlbumin = '',
    this.urineAlbuminReport = '',
    this.ecg = '',
    this.ecgPdf = '',
    this.ecgImage1 = '',
    this.ecgImage2 = '',
    this.ecgImage3 = '',
    this.thyroid = '',
    this.t3 = '',
    this.t4 = '',
    this.tsh = '',
    this.uricAcid = '',
    this.otherInvestigations = '',
    this.investigationDetails = '',
    this.investigations = '',
    this.investigationImage1 = '',
    this.investigationImage2 = '',
    this.investigationImage3 = '',
    // Section 3
    this.improvement = '',
    this.chestPain = '',
    this.chestPainSweating = '',
    this.breathlessness = '',
    this.breathlessWhile = '',
    this.palpitations = '',
    this.giddiness = '',
    this.headache = '',
    this.dizziness = '',
    this.dizzinessSystolic = '',
    this.dizzinessDiaStolic = '',
    this.otherSymptoms = '',
    this.otherSymptomsDetails = '',
    this.systolic2 = '',
    this.diastolic2 = '',
    this.heartRate2 = '',
    this.bleedingEpisode = '',
    // Section 4
    this.smoking = '',
    this.alcohol = '',
    this.reduceSalt = '',
    this.exercise = '',
    this.inStress = '',
    this.missMedicine = '',
    this.lastHospitalization = '',
    this.hospitalizationReason = '',
    this.remindMedicine = 'No',
    this.setAlarm = 'No',
    this.systolic3 = '',
    this.diastolic3 = '',
    this.heartRate3 = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'systolic1': systolic1,
      'diastolic1': diastolic1,
      'heartRate1': heartRate1,
      'height': height,
      'weight': weight,
      'spo2': spo2,
      'spo2Details': spo2Details,
      'bmi': bmi,
      'bpApparatus': bpApparatus,
      'checkSugar': checkSugar,
      'fasting': fasting,
      'afterFood': afterFood,
      'random': random,
      'creatinine': creatinine,
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'vldl': vldl,
      'hba1c': hba1c,
      'hba1cDate': hba1cDate,
      'urineAlbumin': urineAlbumin,
      'urineAlbuminReport': urineAlbuminReport,
      'ecg': ecg,
      'ecgPdf': ecgPdf,
      'ecgImage1': ecgImage1,
      'ecgImage2': ecgImage2,
      'ecgImage3': ecgImage3,
      'thyroid': thyroid,
      't3': t3,
      't4': t4,
      'tsh': tsh,
      'uricAcid': uricAcid,
      'otherInvestigations': otherInvestigations,
      'investigationDetails': investigationDetails,
      'investigations': investigations,
      'investigationImage1': investigationImage1,
      'investigationImage2': investigationImage2,
      'investigationImage3': investigationImage3,
      // Section 3
      'improvement': improvement,
      'chestPain': chestPain,
      'chestPainSweating': chestPainSweating,
      'breathlessness': breathlessness,
      'breathlessWhile': breathlessWhile,
      'palpitations': palpitations,
      'giddiness': giddiness,
      'headache': headache,
      'dizziness': dizziness,
      'dizzinessSystolic': dizzinessSystolic,
      'dizzinessDiaStolic': dizzinessDiaStolic,
      'otherSymptoms': otherSymptoms,
      'otherSymptomsDetails': otherSymptomsDetails,
      'systolic2': systolic2,
      'diastolic2': diastolic2,
      'heartRate2': heartRate2,
      'bleedingEpisode': bleedingEpisode,
      // Section 4
      'smoking': smoking,
      'alcohol': alcohol,
      'reduceSalt': reduceSalt,
      'exercise': exercise,
      'inStress': inStress,
      'missMedicine': missMedicine,
      'lastHospitalization': lastHospitalization,
      'hospitalizationReason': hospitalizationReason,
      'remindMedicine': remindMedicine,
      'setAlarm': setAlarm,
      'systolic3': systolic3,
      'diastolic3': diastolic3,
      'heartRate3': heartRate3,
    };
  }

  factory ClinicalFormDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClinicalFormDetailsModel(
      place: json['place']?.toString() ?? 'Home',
      systolic1: json['systolic1']?.toString() ?? '',
      diastolic1: json['diastolic1']?.toString() ?? '',
      heartRate1: json['heartRate1']?.toString() ?? '',
      height: json['height']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      spo2: json['spo2']?.toString() ?? '',
      spo2Details: json['spo2Details']?.toString() ?? '',
      bmi: json['bmi']?.toString() ?? '',
      bpApparatus: json['bpApparatus']?.toString() ?? '',
      checkSugar: json['checkSugar']?.toString() ?? '',
      fasting: json['fasting']?.toString() ?? '',
      afterFood: json['afterFood']?.toString() ?? '',
      random: json['random']?.toString() ?? '',
      creatinine: json['creatinine']?.toString() ?? '',
      totalCholesterol: json['totalCholesterol']?.toString() ?? '',
      hdl: json['hdl']?.toString() ?? '',
      ldl: json['ldl']?.toString() ?? '',
      vldl: json['vldl']?.toString() ?? '',
      hba1c: json['hba1c']?.toString() ?? '',
      hba1cDate: json['hba1cDate']?.toString() ?? '',
      urineAlbumin: json['urineAlbumin']?.toString() ?? '',
      urineAlbuminReport: json['urineAlbuminReport']?.toString() ?? '',
      ecg: json['ecg']?.toString() ?? '',
      ecgPdf: json['ecgPdf']?.toString() ?? '',
      ecgImage1: json['ecgImage1']?.toString() ?? '',
      ecgImage2: json['ecgImage2']?.toString() ?? '',
      ecgImage3: json['ecgImage3']?.toString() ?? '',
      thyroid: json['thyroid']?.toString() ?? '',
      t3: json['t3']?.toString() ?? '',
      t4: json['t4']?.toString() ?? '',
      tsh: json['tsh']?.toString() ?? '',
      uricAcid: json['uricAcid']?.toString() ?? '',
      otherInvestigations: json['otherInvestigations']?.toString() ?? '',
      investigationDetails: json['investigationDetails']?.toString() ?? '',
      investigations: json['investigations']?.toString() ?? '',
      investigationImage1: json['investigationImage1']?.toString() ?? '',
      investigationImage2: json['investigationImage2']?.toString() ?? '',
      investigationImage3: json['investigationImage3']?.toString() ?? '',
      // Section 3
      improvement: json['improvement']?.toString() ?? '',
      chestPain: json['chestPain']?.toString() ?? '',
      chestPainSweating: json['chestPainSweating']?.toString() ?? '',
      breathlessness: json['breathlessness']?.toString() ?? '',
      breathlessWhile: json['breathlessWhile']?.toString() ?? '',
      palpitations: json['palpitations']?.toString() ?? '',
      giddiness: json['giddiness']?.toString() ?? '',
      headache: json['headache']?.toString() ?? '',
      dizziness: json['dizziness']?.toString() ?? '',
      dizzinessSystolic: json['dizzinessSystolic']?.toString() ?? '',
      dizzinessDiaStolic: json['dizzinessDiaStolic']?.toString() ?? '',
      otherSymptoms: json['otherSymptoms']?.toString() ?? '',
      otherSymptomsDetails: json['otherSymptomsDetails']?.toString() ?? '',
      systolic2: json['systolic2']?.toString() ?? '',
      diastolic2: json['diastolic2']?.toString() ?? '',
      heartRate2: json['heartRate2']?.toString() ?? '',
      bleedingEpisode: json['bleedingEpisode']?.toString() ?? '',
      // Section 4
      smoking: json['smoking']?.toString() ?? '',
      alcohol: json['alcohol']?.toString() ?? '',
      reduceSalt: json['reduceSalt']?.toString() ?? '',
      exercise: json['exercise']?.toString() ?? '',
      inStress: json['inStress']?.toString() ?? '',
      missMedicine: json['missMedicine']?.toString() ?? '',
      lastHospitalization: json['lastHospitalization']?.toString() ?? '',
      hospitalizationReason: json['hospitalizationReason']?.toString() ?? '',
      remindMedicine: json['remindMedicine']?.toString() ?? 'No',
      setAlarm: json['setAlarm']?.toString() ?? 'No',
      systolic3: json['systolic3']?.toString() ?? '',
      diastolic3: json['diastolic3']?.toString() ?? '',
      heartRate3: json['heartRate3']?.toString() ?? '',
    );
  }
}

