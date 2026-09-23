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
  String ecgImage4;
  String ecgImage5;
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
  String investigationImage4;
  String investigationImage5;

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
    this.ecgImage4 = '',
    this.ecgImage5 = '',
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
    this.investigationImage4 = '',
    this.investigationImage5 = '',
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
    String getVal(List<String> keys, [String defaultValue = '']) {
      for (final k in keys) {
        if (json.containsKey(k) && json[k] != null) {
          final str = json[k].toString().trim();
          if (str.isNotEmpty) return str;
        }
      }
      return defaultValue;
    }

    return ClinicalFormDetailsModel(
      place: getVal(['place'], 'Home'),
      systolic1: getVal(['systolic1', 'systolic_1']),
      diastolic1: getVal(['diastolic1', 'diastolic_1']),
      heartRate1: getVal(['heartRate1', 'heart_rate_1', 'heart_rate1']),
      height: getVal(['height']),
      weight: getVal(['weight']),
      spo2: getVal(['spo2']),
      spo2Details: getVal(['spo2Details', 'spo2_details', 'spo2_value']),
      bmi: getVal(['bmi']),
      bpApparatus: getVal([
        'bpApparatus',
        'bp_apparatus',
        'have_bp_apparatus',
        'have_bp_appratus',
      ]),
      checkSugar: getVal(['checkSugar', 'check_sugar']),
      fasting: getVal(['fasting', 'fasting_bsl']),
      afterFood: getVal(['afterFood', 'after_food', 'after_food_bsl']),
      random: getVal(['random', 'random_bsl']),
      creatinine: getVal(['creatinine']),
      totalCholesterol: getVal(['totalCholesterol', 'total_cholesterol']),
      hdl: getVal(['hdl']),
      ldl: getVal(['ldl']),
      vldl: getVal(['vldl']),
      hba1c: getVal(['hba1c']),
      hba1cDate: getVal(['hba1cDate', 'hba1c_date']),
      urineAlbumin: getVal(['urineAlbumin', 'urine_albumin']),
      urineAlbuminReport: getVal([
        'urineAlbuminReport',
        'urine_albumin_report',
      ]),
      ecg: getVal(['ecg']),
      ecgPdf: getVal(['ecgPdf', 'ecg_pdf']),
      ecgImage1: getVal(['ecgImage1', 'ecg_image_1']),
      ecgImage2: getVal(['ecgImage2', 'ecg_image_2']),
      ecgImage3: getVal(['ecgImage3', 'ecg_image_3']),
      ecgImage4: getVal(['ecgImage4', 'ecg_image_4']),
      ecgImage5: getVal(['ecgImage5', 'ecg_image_5']),
      thyroid: getVal(['thyroid']),
      t3: getVal(['t3']),
      t4: getVal(['t4']),
      tsh: getVal(['tsh']),
      uricAcid: getVal(['uricAcid', 'uric_acid']),
      otherInvestigations: getVal([
        'otherInvestigations',
        'other_investigations',
      ]),
      investigationDetails: getVal([
        'investigationDetails',
        'investigation_details',
      ]),
      investigations: getVal(['investigations']),
      investigationImage1: getVal([
        'investigationImage1',
        'investigation_image_1',
      ]),
      investigationImage2: getVal([
        'investigationImage2',
        'investigation_image_2',
      ]),
      investigationImage3: getVal([
        'investigationImage3',
        'investigation_image_3',
      ]),
      // Section 3
      improvement: getVal(['improvement']),
      chestPain: getVal(['chestPain', 'chest_pain']),
      chestPainSweating: getVal(['chestPainSweating', 'chest_pain_sweating']),
      breathlessness: getVal(['breathlessness', 'breathless']),
      breathlessWhile: getVal(['breathlessWhile', 'breathless_while']),
      palpitations: getVal(['palpitations']),
      giddiness: getVal(['giddiness']),
      headache: getVal(['headache']),
      dizziness: getVal(['dizziness']),
      dizzinessSystolic: getVal(['dizzinessSystolic', 'dizziness_systolic']),
      dizzinessDiaStolic: getVal(['dizzinessDiaStolic', 'dizziness_diastolic']),
      otherSymptoms: getVal(['otherSymptoms', 'other_symptoms']),
      otherSymptomsDetails: getVal([
        'otherSymptomsDetails',
        'other_symptom_details',
        'other_symptoms_details',
      ]),
      systolic2: getVal(['systolic2', 'systolic_2']),
      diastolic2: getVal(['diastolic2', 'diastolic_2']),
      heartRate2: getVal(['heartRate2', 'heart_rate_2', 'heart_rate2']),
      bleedingEpisode: getVal(['bleedingEpisode', 'bleeding_episode']),
      // Section 4
      smoking: getVal(['smoking']),
      alcohol: getVal(['alcohol']),
      reduceSalt: getVal(['reduceSalt', 'reduce_salt']),
      exercise: getVal(['exercise']),
      inStress: getVal(['inStress', 'in_stress']),
      missMedicine: getVal(['missMedicine', 'miss_medicine']),
      lastHospitalization: getVal([
        'lastHospitalization',
        'last_hospitalization',
      ]),
      hospitalizationReason: getVal([
        'hospitalizationReason',
        'hospitalization_reason',
      ]),
      remindMedicine: getVal(['remindMedicine', 'remind_medicine'], 'No'),
      setAlarm: getVal(['setAlarm', 'set_alarm'], 'No'),
      systolic3: getVal(['systolic3', 'systolic_3']),
      diastolic3: getVal(['diastolic3', 'diastolic_3']),
      heartRate3: getVal(['heartRate3', 'heart_rate_3', 'heart_rate3']),
    );
  }
}
