class MedicalFormDetailResponse {
  final String status;
  final String msg;
  final MedicalFormDataModel? data;

  MedicalFormDetailResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory MedicalFormDetailResponse.fromJson(Map<String, dynamic> json) {
    return MedicalFormDetailResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? MedicalFormDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class MedicalFormDataModel {
  final String? id;
  final String? patientId;
  final String? doctorId;
  final String? filledUserType;

  // Section 1: Clinical History
  final String? hypertension;
  final String? htnSince;
  final String? htnMed;
  final String? htnMedName1;
  final String? htnMedName2;
  final String? htnMedName3;
  final String? htnMedFreq1;
  final String? htnMedFreq2;
  final String? htnMedFreq3;
  final String? htnMedImg1;
  final String? htnMedImg2;
  final String? htnMedImg3;
  final String? htnMedRegular;

  final String? diabetes;
  final String? diaSince;
  final String? diaMed;
  final String? diaMedName1;
  final String? diaMedName2;
  final String? diaMedName3;
  final String? diaMedFreq1;
  final String? diaMedFreq2;
  final String? diaMedFreq3;
  final String? diaMedImg1;
  final String? diaMedImg2;
  final String? diaMedImg3;
  final String? diaMedRegular;

  final String? thyroid;
  final String? thyroidSince;
  final String? thyroidMed;
  final String? thyroidMedName1;
  final String? thyroidMedName2;
  final String? thyroidMedName3;
  final String? thyroidMedFreq1;
  final String? thyroidMedFreq2;
  final String? thyroidMedFreq3;
  final String? thyroidMedImg1;
  final String? thyroidMedImg2;
  final String? thyroidMedImg3;
  final String? thyroidMedRegular;

  final String? cholesterol;
  final String? asthma;
  final String? isPregnant;
  final String? htnDiaPregnancy;

  // Section 2: Past History
  final String? heartAttack;
  final String? heartAtkWhen;
  final String? heartAtkMed;
  final String? heartAtkStatus;
  final String? heartAtkMedName1;
  final String? heartAtkMedName2;
  final String? heartAtkMedName3;
  final String? heartAtkMedFreq1;
  final String? heartAtkMedFreq2;
  final String? heartAtkMedFreq3;
  final String? hrtAtkMedImg1;
  final String? hrtAtkMedImg2;
  final String? hrtAtkMedImg3;

  final String? stroke;
  final String? strokeWhen;
  final String? strokeMed;
  final String? strokeStatus;
  final String? strokeMedName1;
  final String? strokeMedName2;
  final String? strokeMedName3;
  final String? strokeMedFreq1;
  final String? strokeMedFreq2;
  final String? strokeMedFreq3;
  final String? strokeMedImg1;
  final String? strokeMedImg2;
  final String? strokeMedImg3;

  final String? kidneyFailure;
  final String? kidneyFailWhen;
  final String? kidneyFailMed;
  final String? kidneyFailureStatus;
  final String? dialysis;
  final String? dialysisFrequency;
  final String? kidneyFailMedName1;
  final String? kidneyFailMedName2;
  final String? kidneyFailMedName3;
  final String? kidneyFailMedFreq1;
  final String? kidneyFailMedFreq2;
  final String? kidneyFailMedFreq3;
  final String? kidneyFailMedImg1;
  final String? kidneyFailMedImg2;
  final String? kidneyFailMedImg3;

  final String? angioplasty;
  final String? angioplastyWhen;
  final String? angioplastyMed;
  final String? stent;
  final String? brilinta;
  final String? clopilet;
  final String? prasita;
  final String? angioplastyMedName1;
  final String? angioplastyMedName2;
  final String? angioplastyMedName3;
  final String? angioplastyMedFreq1;
  final String? angioplastyMedFreq2;
  final String? angioplastyMedFreq3;
  final String? angioplastyMedImg1;
  final String? angioplastyMedImg2;
  final String? angioplastyMedImg3;

  final String? bypassSurgery;
  final String? bypassSurgWhen;
  final String? bypassSurgMed;
  final String? bypassSurgMedName1;
  final String? bypassSurgMedName2;
  final String? bypassSurgMedName3;
  final String? bypassSurgMedFreq1;
  final String? bypassSurgMedFreq2;
  final String? bypassSurgMedFreq3;
  final String? bypassSurgMedImg1;
  final String? bypassSurgMedImg2;
  final String? bypassSurgMedImg3;

  final String? medAllergy;
  final String? allergicTo;
  final String? allergyMedName1;
  final String? allergyMedName2;
  final String? allergyMedName3;

  final String? bleedingTendency;
  final String? bleedingFrequency;
  final String? onMedicine;

  final String? otherSurgery;
  final String? surgeryType;
  final String? otherSurgName1;
  final String? otherSurgName2;
  final String? otherSurgName3;

  final String? created;
  final String? updated;

  // Section 3: Family History
  final String? familyMemberHeartAttack;
  final String? familyMemberHeartAttackWho;
  final String? heartAttackFatherAge;
  final String? heartAttackMotherAge;
  final String? heartAttackBrotherAge;
  final String? heartAttackSisterAge;
  final String? heartAttackGrandparentsAge;
  final String? familyHeartAttackFrequency;

  final String? familyMemberStroke;
  final String? familyMemberStrokeWho;
  final String? strokeFatherAge;
  final String? strokeMotherAge;
  final String? strokeBrotherAge;
  final String? strokeSisterAge;
  final String? strokeGrandparentsAge;
  final String? familyStrokeFrequency;

  final String? familyMemberAngioplasty;
  final String? familyMemberAngioplastyWho;
  final String? angioplastyFatherAge;
  final String? angioplastyMotherAge;
  final String? angioplastyBrotherAge;
  final String? angioplastySisterAge;
  final String? angioplastyGrandparentsAge;
  final String? angioplastyComments;

  final String? familyMemberDied;
  final String? familyMemberDiedWho;
  final String? diedFatherAge;
  final String? diedMotherAge;
  final String? diedBrotherAge;
  final String? diedSisterAge;
  final String? diedGrandparentsAge;
  final String? familyMemberDiedReason;

  // Section 4: Personal Habits
  final String? smoke;
  final String? dailyCigaretteCount;
  final String? smokeStopBefore;
  final String? alcohol;
  final String? extraSalt;
  final String? familyMemberCount;
  final String? morningWalk;
  final String? yoga;

  // Section 5: Vitals & Evaluation
  final String? height;
  final String? weight;
  final String? bpSystolic;
  final String? bpDiastolic;
  final String? otherInfo;
  final String? otherInfoName;
  final String? firstEvaluationImpression;
  final String? otherCare;
  final String? otherCareComments;

  MedicalFormDataModel({
    this.id,
    this.patientId,
    this.doctorId,
    this.filledUserType,
    this.hypertension,
    this.htnSince,
    this.htnMed,
    this.htnMedName1,
    this.htnMedName2,
    this.htnMedName3,
    this.htnMedFreq1,
    this.htnMedFreq2,
    this.htnMedFreq3,
    this.htnMedImg1,
    this.htnMedImg2,
    this.htnMedImg3,
    this.htnMedRegular,
    this.diabetes,
    this.diaSince,
    this.diaMed,
    this.diaMedName1,
    this.diaMedName2,
    this.diaMedName3,
    this.diaMedFreq1,
    this.diaMedFreq2,
    this.diaMedFreq3,
    this.diaMedImg1,
    this.diaMedImg2,
    this.diaMedImg3,
    this.diaMedRegular,
    this.thyroid,
    this.thyroidSince,
    this.thyroidMed,
    this.thyroidMedName1,
    this.thyroidMedName2,
    this.thyroidMedName3,
    this.thyroidMedFreq1,
    this.thyroidMedFreq2,
    this.thyroidMedFreq3,
    this.thyroidMedImg1,
    this.thyroidMedImg2,
    this.thyroidMedImg3,
    this.thyroidMedRegular,
    this.cholesterol,
    this.asthma,
    this.isPregnant,
    this.htnDiaPregnancy,
    this.heartAttack,
    this.heartAtkWhen,
    this.heartAtkMed,
    this.heartAtkStatus,
    this.heartAtkMedName1,
    this.heartAtkMedName2,
    this.heartAtkMedName3,
    this.heartAtkMedFreq1,
    this.heartAtkMedFreq2,
    this.heartAtkMedFreq3,
    this.hrtAtkMedImg1,
    this.hrtAtkMedImg2,
    this.hrtAtkMedImg3,
    this.stroke,
    this.strokeWhen,
    this.strokeMed,
    this.strokeStatus,
    this.strokeMedName1,
    this.strokeMedName2,
    this.strokeMedName3,
    this.strokeMedFreq1,
    this.strokeMedFreq2,
    this.strokeMedFreq3,
    this.strokeMedImg1,
    this.strokeMedImg2,
    this.strokeMedImg3,
    this.kidneyFailure,
    this.kidneyFailWhen,
    this.kidneyFailMed,
    this.kidneyFailureStatus,
    this.dialysis,
    this.dialysisFrequency,
    this.kidneyFailMedName1,
    this.kidneyFailMedName2,
    this.kidneyFailMedName3,
    this.kidneyFailMedFreq1,
    this.kidneyFailMedFreq2,
    this.kidneyFailMedFreq3,
    this.kidneyFailMedImg1,
    this.kidneyFailMedImg2,
    this.kidneyFailMedImg3,
    this.angioplasty,
    this.angioplastyWhen,
    this.angioplastyMed,
    this.stent,
    this.brilinta,
    this.clopilet,
    this.prasita,
    this.angioplastyMedName1,
    this.angioplastyMedName2,
    this.angioplastyMedName3,
    this.angioplastyMedFreq1,
    this.angioplastyMedFreq2,
    this.angioplastyMedFreq3,
    this.angioplastyMedImg1,
    this.angioplastyMedImg2,
    this.angioplastyMedImg3,
    this.bypassSurgery,
    this.bypassSurgWhen,
    this.bypassSurgMed,
    this.bypassSurgMedName1,
    this.bypassSurgMedName2,
    this.bypassSurgMedName3,
    this.bypassSurgMedFreq1,
    this.bypassSurgMedFreq2,
    this.bypassSurgMedFreq3,
    this.bypassSurgMedImg1,
    this.bypassSurgMedImg2,
    this.bypassSurgMedImg3,
    this.medAllergy,
    this.allergicTo,
    this.allergyMedName1,
    this.allergyMedName2,
    this.allergyMedName3,
    this.bleedingTendency,
    this.bleedingFrequency,
    this.onMedicine,
    this.otherSurgery,
    this.surgeryType,
    this.otherSurgName1,
    this.otherSurgName2,
    this.otherSurgName3,
    this.created,
    this.updated,
    this.familyMemberHeartAttack,
    this.familyMemberHeartAttackWho,
    this.heartAttackFatherAge,
    this.heartAttackMotherAge,
    this.heartAttackBrotherAge,
    this.heartAttackSisterAge,
    this.heartAttackGrandparentsAge,
    this.familyHeartAttackFrequency,
    this.familyMemberStroke,
    this.familyMemberStrokeWho,
    this.strokeFatherAge,
    this.strokeMotherAge,
    this.strokeBrotherAge,
    this.strokeSisterAge,
    this.strokeGrandparentsAge,
    this.familyStrokeFrequency,
    this.familyMemberAngioplasty,
    this.familyMemberAngioplastyWho,
    this.angioplastyFatherAge,
    this.angioplastyMotherAge,
    this.angioplastyBrotherAge,
    this.angioplastySisterAge,
    this.angioplastyGrandparentsAge,
    this.angioplastyComments,
    this.familyMemberDied,
    this.familyMemberDiedWho,
    this.diedFatherAge,
    this.diedMotherAge,
    this.diedBrotherAge,
    this.diedSisterAge,
    this.diedGrandparentsAge,
    this.familyMemberDiedReason,
    this.smoke,
    this.dailyCigaretteCount,
    this.smokeStopBefore,
    this.alcohol,
    this.extraSalt,
    this.familyMemberCount,
    this.morningWalk,
    this.yoga,
    this.height,
    this.weight,
    this.bpSystolic,
    this.bpDiastolic,
    this.otherInfo,
    this.otherInfoName,
    this.firstEvaluationImpression,
    this.otherCare,
    this.otherCareComments,
  });

  factory MedicalFormDataModel.fromJson(Map<String, dynamic> json) {
    return MedicalFormDataModel(
      id: json['id']?.toString(),
      patientId: json['patient_id']?.toString(),
      doctorId: json['doctor_id']?.toString(),
      filledUserType: json['filled_user_type']?.toString(),
      hypertension: json['hypertension']?.toString(),
      htnSince: json['htn_since']?.toString(),
      htnMed: json['htn_med']?.toString(),
      htnMedName1: json['htn_med_name_1']?.toString(),
      htnMedName2: json['htn_med_name_2']?.toString(),
      htnMedName3: json['htn_med_name_3']?.toString(),
      htnMedFreq1: json['htn_med_freq_1']?.toString(),
      htnMedFreq2: json['htn_med_freq_2']?.toString(),
      htnMedFreq3: json['htn_med_freq_3']?.toString(),
      htnMedImg1: json['htn_med_img_1']?.toString(),
      htnMedImg2: json['htn_med_img_2']?.toString(),
      htnMedImg3: json['htn_med_img_3']?.toString(),
      htnMedRegular: json['htn_med_regular']?.toString(),
      diabetes: json['diabetes']?.toString(),
      diaSince: json['dia_since']?.toString(),
      diaMed: json['dia_med']?.toString(),
      diaMedName1: json['dia_med_name_1']?.toString(),
      diaMedName2: json['dia_med_name_2']?.toString(),
      diaMedName3: json['dia_med_name_3']?.toString(),
      diaMedFreq1: json['dia_med_freq_1']?.toString(),
      diaMedFreq2: json['dia_med_freq_2']?.toString(),
      diaMedFreq3: json['dia_med_freq_3']?.toString(),
      diaMedImg1: json['dia_med_img_1']?.toString(),
      diaMedImg2: json['dia_med_img_2']?.toString(),
      diaMedImg3: json['dia_med_img_3']?.toString(),
      diaMedRegular: json['dia_med_regular']?.toString(),
      thyroid: json['thyroid']?.toString(),
      thyroidSince: json['thyroid_since']?.toString(),
      thyroidMed: json['thyroid_med']?.toString(),
      thyroidMedName1: json['thyroid_med_name_1']?.toString(),
      thyroidMedName2: json['thyroid_med_name_2']?.toString(),
      thyroidMedName3: json['thyroid_med_name_3']?.toString(),
      thyroidMedFreq1: json['thyroid_med_freq_1']?.toString(),
      thyroidMedFreq2: json['thyroid_med_freq_2']?.toString(),
      thyroidMedFreq3: json['thyroid_med_freq_3']?.toString(),
      thyroidMedImg1: json['thyroid_med_img_1']?.toString(),
      thyroidMedImg2: json['thyroid_med_img_2']?.toString(),
      thyroidMedImg3: json['thyroid_med_img_3']?.toString(),
      thyroidMedRegular: json['thyroid_med_regular']?.toString(),
      cholesterol: json['cholesterol']?.toString(),
      asthma: json['asthma']?.toString(),
      isPregnant: json['is_pregnant']?.toString(),
      htnDiaPregnancy: json['htn_dia_pregnancy']?.toString(),
      heartAttack: json['heart_attack']?.toString(),
      heartAtkWhen: json['heart_atk_when']?.toString(),
      heartAtkMed: json['heart_atk_med']?.toString(),
      heartAtkStatus: json['heart_atk_status']?.toString(),
      heartAtkMedName1: json['heart_atk_med_name_1']?.toString(),
      heartAtkMedName2: json['heart_atk_med_name_2']?.toString(),
      heartAtkMedName3: json['heart_atk_med_name_3']?.toString(),
      heartAtkMedFreq1: json['heart_atk_med_freq_1']?.toString(),
      heartAtkMedFreq2: json['heart_atk_med_freq_2']?.toString(),
      heartAtkMedFreq3: json['heart_atk_med_freq_3']?.toString(),
      hrtAtkMedImg1: json['hrt_atk_med_img_1']?.toString(),
      hrtAtkMedImg2: json['hrt_atk_med_img_2']?.toString(),
      hrtAtkMedImg3: json['hrt_atk_med_img_3']?.toString(),
      stroke: json['stroke']?.toString(),
      strokeWhen: json['stroke_when']?.toString(),
      strokeMed: json['stroke_med']?.toString(),
      strokeStatus: json['stroke_status']?.toString(),
      strokeMedName1: json['stroke_med_name_1']?.toString(),
      strokeMedName2: json['stroke_med_name_2']?.toString(),
      strokeMedName3: json['stroke_med_name_3']?.toString(),
      strokeMedFreq1: json['stroke_med_freq_1']?.toString(),
      strokeMedFreq2: json['stroke_med_freq_2']?.toString(),
      strokeMedFreq3: json['stroke_med_freq_3']?.toString(),
      strokeMedImg1: json['stroke_med_img_1']?.toString(),
      strokeMedImg2: json['stroke_med_img_2']?.toString(),
      strokeMedImg3: json['stroke_med_img_3']?.toString(),
      kidneyFailure: json['kidney_failure']?.toString(),
      kidneyFailWhen: json['kidney_fail_when']?.toString(),
      kidneyFailMed: json['kidney_fail_med']?.toString(),
      kidneyFailureStatus: json['kidney_failure_status']?.toString(),
      dialysis: json['dialysis']?.toString(),
      dialysisFrequency: json['dialysis_frequency']?.toString(),
      kidneyFailMedName1: json['kidney_fail_med_name_1']?.toString(),
      kidneyFailMedName2: json['kidney_fail_med_name_2']?.toString(),
      kidneyFailMedName3: json['kidney_fail_med_name_3']?.toString(),
      kidneyFailMedFreq1: json['kidney_fail_med_freq_1']?.toString(),
      kidneyFailMedFreq2: json['kidney_fail_med_freq_2']?.toString(),
      kidneyFailMedFreq3: json['kidney_fail_med_freq_3']?.toString(),
      kidneyFailMedImg1: json['kidney_fail_med_img_1']?.toString(),
      kidneyFailMedImg2: json['kidney_fail_med_img_2']?.toString(),
      kidneyFailMedImg3: json['kidney_fail_med_img_3']?.toString(),
      angioplasty: json['angioplasty']?.toString(),
      angioplastyWhen: json['angioplasty_when']?.toString(),
      angioplastyMed: json['angioplasty_med']?.toString(),
      stent: json['stent']?.toString(),
      brilinta: json['brilinta']?.toString(),
      clopilet: json['clopilet']?.toString(),
      prasita: json['prasita']?.toString(),
      angioplastyMedName1: json['angioplasty_med_name_1']?.toString(),
      angioplastyMedName2: json['angioplasty_med_name_2']?.toString(),
      angioplastyMedName3: json['angioplasty_med_name_3']?.toString(),
      angioplastyMedFreq1: json['angioplasty_med_freq_1']?.toString(),
      angioplastyMedFreq2: json['angioplasty_med_freq_2']?.toString(),
      angioplastyMedFreq3: json['angioplasty_med_freq_3']?.toString(),
      angioplastyMedImg1: json['angioplasty_med_img_1']?.toString(),
      angioplastyMedImg2: json['angioplasty_med_img_2']?.toString(),
      angioplastyMedImg3: json['angioplasty_med_img_3']?.toString(),
      bypassSurgery: json['bypass_surgery']?.toString(),
      bypassSurgWhen: json['bypass_surg_when']?.toString(),
      bypassSurgMed: json['bypass_surg_med']?.toString(),
      bypassSurgMedName1: json['bypass_surg_med_name_1']?.toString(),
      bypassSurgMedName2: json['bypass_surg_med_name_2']?.toString(),
      bypassSurgMedName3: json['bypass_surg_med_name_3']?.toString(),
      bypassSurgMedFreq1: json['bypass_surg_med_freq_1']?.toString(),
      bypassSurgMedFreq2: json['bypass_surg_med_freq_2']?.toString(),
      bypassSurgMedFreq3: json['bypass_surg_med_freq_3']?.toString(),
      bypassSurgMedImg1: json['bypass_surg_med_img_1']?.toString(),
      bypassSurgMedImg2: json['bypass_surg_med_img_2']?.toString(),
      bypassSurgMedImg3: json['bypass_surg_med_img_3']?.toString(),
      medAllergy: json['med_allergy']?.toString(),
      allergicTo: json['allergic_to']?.toString(),
      allergyMedName1: json['allergy_med_name_1']?.toString(),
      allergyMedName2: json['allergy_med_name_2']?.toString(),
      allergyMedName3: json['allergy_med_name_3']?.toString(),
      bleedingTendency: json['bleeding_tendency']?.toString(),
      bleedingFrequency: json['bleeding_frequency']?.toString(),
      onMedicine: json['on_medicine']?.toString(),
      otherSurgery: json['other_surgery']?.toString(),
      surgeryType: json['surgery_type']?.toString(),
      otherSurgName1: json['other_surg_name_1']?.toString(),
      otherSurgName2: json['other_surg_name_2']?.toString(),
      otherSurgName3: json['other_surg_name_3']?.toString(),
      created: json['created']?.toString(),
      updated: json['updated']?.toString(),
      familyMemberHeartAttack: json['family_member_heart_attack']?.toString(),
      familyMemberHeartAttackWho: json['family_member_heart_attack_who']?.toString(),
      heartAttackFatherAge: json['heart_attack_father_age']?.toString(),
      heartAttackMotherAge: json['heart_attack_mother_age']?.toString(),
      heartAttackBrotherAge: json['heart_attack_brother_age']?.toString(),
      heartAttackSisterAge: json['heart_attack_sister_age']?.toString(),
      heartAttackGrandparentsAge: json['heart_attack_grandparents_age']?.toString(),
      familyHeartAttackFrequency: json['family_heart_attack_frequency']?.toString(),
      familyMemberStroke: json['family_member_stroke']?.toString(),
      familyMemberStrokeWho: json['family_member_stroke_who']?.toString(),
      strokeFatherAge: json['stroke_father_age']?.toString(),
      strokeMotherAge: json['stroke_mother_age']?.toString(),
      strokeBrotherAge: json['stroke_brother_age']?.toString(),
      strokeSisterAge: json['stroke_sister_age']?.toString(),
      strokeGrandparentsAge: json['stroke_grandparents_age']?.toString(),
      familyStrokeFrequency: json['family_stroke_frequency']?.toString(),
      familyMemberAngioplasty: json['family_member_angioplasty']?.toString(),
      familyMemberAngioplastyWho: json['family_member_angioplasty_who']?.toString(),
      angioplastyFatherAge: json['angioplasty_father_age']?.toString(),
      angioplastyMotherAge: json['angioplasty_mother_age']?.toString(),
      angioplastyBrotherAge: json['angioplasty_brother_age']?.toString(),
      angioplastySisterAge: json['angioplasty_sister_age']?.toString(),
      angioplastyGrandparentsAge: json['angioplasty_grandparents_age']?.toString(),
      angioplastyComments: json['angioplasty_comments']?.toString(),
      familyMemberDied: json['family_member_died']?.toString(),
      familyMemberDiedWho: json['family_member_died_who']?.toString(),
      diedFatherAge: json['died_father_age']?.toString(),
      diedMotherAge: json['died_mother_age']?.toString(),
      diedBrotherAge: json['died_brother_age']?.toString(),
      diedSisterAge: json['died_sister_age']?.toString(),
      diedGrandparentsAge: json['died_grandparents_age']?.toString(),
      familyMemberDiedReason: json['family_member_died_reason']?.toString(),
      smoke: json['smoke']?.toString(),
      dailyCigaretteCount: json['daily_cigarette_count']?.toString(),
      smokeStopBefore: json['smoke_stop_before']?.toString(),
      alcohol: json['alcohol']?.toString(),
      extraSalt: json['extra_salt']?.toString(),
      familyMemberCount: json['family_member_count']?.toString(),
      morningWalk: json['morning_walk']?.toString(),
      yoga: json['yoga']?.toString(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      bpSystolic: json['bp_systolic']?.toString(),
      bpDiastolic: json['bp_diastolic']?.toString(),
      otherInfo: json['other_info']?.toString(),
      otherInfoName: json['other_info_name']?.toString(),
      firstEvaluationImpression: json['first_evaluation_impression']?.toString(),
      otherCare: json['other_care']?.toString(),
      otherCareComments: json['other_care_comments']?.toString(),
    );
  }
}
