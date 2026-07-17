class MedicalFormDetailsModel {
  // Section 1
  String hypertension;
  String hypertensionSince;
  String hypertensionMed;
  String hyperMedRegular;
  String hypertensionMedName1;
  String hypertensionMedName2;
  String hypertensionMedName3;
  String hypertensionMedFreq1;
  String hypertensionMedFreq2;
  String hypertensionMedFreq3;
  String htnImage1;
  String htnImage2;
  String htnImage3;

  String diabetes;
  String diabetesSince;
  String diabetesMed;
  String diabetesMedRegular;
  String diabetesMedName1;
  String diabetesMedName2;
  String diabetesMedName3;
  String diabetesMedFreq1;
  String diabetesMedFreq2;
  String diabetesMedFreq3;
  String diabetesImage1;
  String diabetesImage2;
  String diabetesImage3;

  String thyroid;
  String thyroidSince;
  String thyroidMed;
  String thyroidMedRegular;
  String thyroidMedName1;
  String thyroidMedName2;
  String thyroidMedName3;
  String thyroidMedFreq1;
  String thyroidMedFreq2;
  String thyroidMedFreq3;
  String thyroidImage1;
  String thyroidImage2;
  String thyroidImage3;

  String cholestrol;
  String asthma;
  String pregnant;
  String duringPregnancy;

  // Section 2
  String heartAttack;
  String heartAttackWhen;
  String heartAttackOnMedicine;
  String heartAttackMedName1;
  String heartAttackMedName2;
  String heartAttackMedName3;
  String heartAttackMedFreq1;
  String heartAttackMedFreq2;
  String heartAttackMedFreq3;
  String heartAttackImage1;
  String heartAttackImage2;
  String heartAttackImage3;

  String stroke;
  String strokeWhen;
  String strokeOnMedicine;
  String strokeMedName1;
  String strokeMedName2;
  String strokeMedName3;
  String strokeMedFreq1;
  String strokeMedFreq2;
  String strokeMedFreq3;
  String strokeImage1;
  String strokeImage2;
  String strokeImage3;

  String kidneyFailure;
  String kidneyFailureWhen;
  String kidneyFailureOnMedicine;
  String kidneyFailureMedName1;
  String kidneyFailureMedName2;
  String kidneyFailureMedName3;
  String kidneyFailureMedFreq1;
  String kidneyFailureMedFreq2;
  String kidneyFailureMedFreq3;
  String kidneyFailImage1;
  String kidneyFailImage2;
  String kidneyFailImage3;

  String angioplasty;
  String angioplastyWhen;
  String angioplastyOnMedicine;
  String angioplastyMedName1;
  String angioplastyMedName2;
  String angioplastyMedName3;
  String angioplastyMedFreq1;
  String angioplastyMedFreq2;
  String angioplastyMedFreq3;
  String angioplastyImage1;
  String angioplastyImage2;
  String angioplastyImage3;

  String bypass;
  String bypassWhen;
  String bypassOnMedicine;
  String bypassMedName1;
  String bypassMedName2;
  String bypassMedName3;
  String bypassMedFreq1;
  String bypassMedFreq2;
  String bypassMedFreq3;
  String bypassImage1;
  String bypassImage2;
  String bypassImage3;

  String medAllergy;
  String allergyMedName1;
  String allergyMedName2;
  String allergyMedName3;

  String bleedingTendency;

  String otherSurgery;
  String surgeryName1;
  String surgeryName2;
  String surgeryName3;

  MedicalFormDetailsModel({
    this.hypertension = '',
    this.hypertensionSince = '',
    this.hypertensionMed = '',
    this.hyperMedRegular = '',
    this.hypertensionMedName1 = '',
    this.hypertensionMedName2 = '',
    this.hypertensionMedName3 = '',
    this.hypertensionMedFreq1 = '',
    this.hypertensionMedFreq2 = '',
    this.hypertensionMedFreq3 = '',
    this.htnImage1 = '',
    this.htnImage2 = '',
    this.htnImage3 = '',
    this.diabetes = '',
    this.diabetesSince = '',
    this.diabetesMed = '',
    this.diabetesMedRegular = '',
    this.diabetesMedName1 = '',
    this.diabetesMedName2 = '',
    this.diabetesMedName3 = '',
    this.diabetesMedFreq1 = '',
    this.diabetesMedFreq2 = '',
    this.diabetesMedFreq3 = '',
    this.diabetesImage1 = '',
    this.diabetesImage2 = '',
    this.diabetesImage3 = '',
    this.thyroid = '',
    this.thyroidSince = '',
    this.thyroidMed = '',
    this.thyroidMedRegular = '',
    this.thyroidMedName1 = '',
    this.thyroidMedName2 = '',
    this.thyroidMedName3 = '',
    this.thyroidMedFreq1 = '',
    this.thyroidMedFreq2 = '',
    this.thyroidMedFreq3 = '',
    this.thyroidImage1 = '',
    this.thyroidImage2 = '',
    this.thyroidImage3 = '',
    this.cholestrol = '',
    this.asthma = '',
    this.pregnant = '',
    this.duringPregnancy = '',
    // Section 2
    this.heartAttack = '',
    this.heartAttackWhen = '',
    this.heartAttackOnMedicine = '',
    this.heartAttackMedName1 = '',
    this.heartAttackMedName2 = '',
    this.heartAttackMedName3 = '',
    this.heartAttackMedFreq1 = '',
    this.heartAttackMedFreq2 = '',
    this.heartAttackMedFreq3 = '',
    this.heartAttackImage1 = '',
    this.heartAttackImage2 = '',
    this.heartAttackImage3 = '',
    this.stroke = '',
    this.strokeWhen = '',
    this.strokeOnMedicine = '',
    this.strokeMedName1 = '',
    this.strokeMedName2 = '',
    this.strokeMedName3 = '',
    this.strokeMedFreq1 = '',
    this.strokeMedFreq2 = '',
    this.strokeMedFreq3 = '',
    this.strokeImage1 = '',
    this.strokeImage2 = '',
    this.strokeImage3 = '',
    this.kidneyFailure = '',
    this.kidneyFailureWhen = '',
    this.kidneyFailureOnMedicine = '',
    this.kidneyFailureMedName1 = '',
    this.kidneyFailureMedName2 = '',
    this.kidneyFailureMedName3 = '',
    this.kidneyFailureMedFreq1 = '',
    this.kidneyFailureMedFreq2 = '',
    this.kidneyFailureMedFreq3 = '',
    this.kidneyFailImage1 = '',
    this.kidneyFailImage2 = '',
    this.kidneyFailImage3 = '',
    this.angioplasty = '',
    this.angioplastyWhen = '',
    this.angioplastyOnMedicine = '',
    this.angioplastyMedName1 = '',
    this.angioplastyMedName2 = '',
    this.angioplastyMedName3 = '',
    this.angioplastyMedFreq1 = '',
    this.angioplastyMedFreq2 = '',
    this.angioplastyMedFreq3 = '',
    this.angioplastyImage1 = '',
    this.angioplastyImage2 = '',
    this.angioplastyImage3 = '',
    this.bypass = '',
    this.bypassWhen = '',
    this.bypassOnMedicine = '',
    this.bypassMedName1 = '',
    this.bypassMedName2 = '',
    this.bypassMedName3 = '',
    this.bypassMedFreq1 = '',
    this.bypassMedFreq2 = '',
    this.bypassMedFreq3 = '',
    this.bypassImage1 = '',
    this.bypassImage2 = '',
    this.bypassImage3 = '',
    this.medAllergy = '',
    this.allergyMedName1 = '',
    this.allergyMedName2 = '',
    this.allergyMedName3 = '',
    this.bleedingTendency = '',
    this.otherSurgery = '',
    this.surgeryName1 = '',
    this.surgeryName2 = '',
    this.surgeryName3 = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'hypertension': hypertension,
      'hypertension_since': hypertensionSince,
      'hypertension_med': hypertensionMed,
      'hyper_med_regular': hyperMedRegular,
      'hypertension_med_name_1': hypertensionMedName1,
      'hypertension_med_name_2': hypertensionMedName2,
      'hypertension_med_name_3': hypertensionMedName3,
      'hypertension_med_freq_1': hypertensionMedFreq1,
      'hypertension_med_freq_2': hypertensionMedFreq2,
      'hypertension_med_freq_3': hypertensionMedFreq3,
      'htn_image_1': htnImage1,
      'htn_image_2': htnImage2,
      'htn_image_3': htnImage3,
      'diabetes': diabetes,
      'diabetes_since': diabetesSince,
      'diabetes_med': diabetesMed,
      'diabetes_med_regular': diabetesMedRegular,
      'diabetes_med_name_1': diabetesMedName1,
      'diabetes_med_name_2': diabetesMedName2,
      'diabetes_med_name_3': diabetesMedName3,
      'diabetes_med_freq_1': diabetesMedFreq1,
      'diabetes_med_freq_2': diabetesMedFreq2,
      'diabetes_med_freq_3': diabetesMedFreq3,
      'diabetes_image_1': diabetesImage1,
      'diabetes_image_2': diabetesImage2,
      'diabetes_image_3': diabetesImage3,
      'thyroid': thyroid,
      'thyroid_since': thyroidSince,
      'thyroid_med': thyroidMed,
      'thyroid_med_regular': thyroidMedRegular,
      'thyroid_med_name_1': thyroidMedName1,
      'thyroid_med_name_2': thyroidMedName2,
      'thyroid_med_name_3': thyroidMedName3,
      'thyroid_med_freq_1': thyroidMedFreq1,
      'thyroid_med_freq_2': thyroidMedFreq2,
      'thyroid_med_freq_3': thyroidMedFreq3,
      'thyroid_image_1': thyroidImage1,
      'thyroid_image_2': thyroidImage2,
      'thyroid_image_3': thyroidImage3,
      'cholestrol': cholestrol,
      'asthma': asthma,
      'pregnant': pregnant,
      'during_pregnancy': duringPregnancy,
      // Section 2
      'heart_attack': heartAttack,
      'heart_attack_when': heartAttackWhen,
      'heart_attack_on_medicine': heartAttackOnMedicine,
      'heart_attack_med_name_1': heartAttackMedName1,
      'heart_attack_med_name_2': heartAttackMedName2,
      'heart_attack_med_name_3': heartAttackMedName3,
      'heart_attack_med_freq_1': heartAttackMedFreq1,
      'heart_attack_med_freq_2': heartAttackMedFreq2,
      'heart_attack_med_freq_3': heartAttackMedFreq3,
      'heart_attack_image_1': heartAttackImage1,
      'heart_attack_image_2': heartAttackImage2,
      'heart_attack_image_3': heartAttackImage3,
      'stroke': stroke,
      'stroke_when': strokeWhen,
      'stroke_on_medicine': strokeOnMedicine,
      'stroke_med_name_1': strokeMedName1,
      'stroke_med_name_2': strokeMedName2,
      'stroke_med_name_3': strokeMedName3,
      'stroke_med_freq_1': strokeMedFreq1,
      'stroke_med_freq_2': strokeMedFreq2,
      'stroke_med_freq_3': strokeMedFreq3,
      'stroke_image_1': strokeImage1,
      'stroke_image_2': strokeImage2,
      'stroke_image_3': strokeImage3,
      'kidney_failure': kidneyFailure,
      'kidney_failure_when': kidneyFailureWhen,
      'kidney_failure_on_medicine': kidneyFailureOnMedicine,
      'kidney_failure_med_name_1': kidneyFailureMedName1,
      'kidney_failure_med_name_2': kidneyFailureMedName2,
      'kidney_failure_med_name_3': kidneyFailureMedName3,
      'kidney_failure_med_freq_1': kidneyFailureMedFreq1,
      'kidney_failure_med_freq_2': kidneyFailureMedFreq2,
      'kidney_failure_med_freq_3': kidneyFailureMedFreq3,
      'kidney_fail_image_1': kidneyFailImage1,
      'kidney_fail_image_2': kidneyFailImage2,
      'kidney_fail_image_3': kidneyFailImage3,
      'angioplasty': angioplasty,
      'angioplasty_when': angioplastyWhen,
      'angioplasty_on_medicine': angioplastyOnMedicine,
      'angioplasty_med_name_1': angioplastyMedName1,
      'angioplasty_med_name_2': angioplastyMedName2,
      'angioplasty_med_name_3': angioplastyMedName3,
      'angioplasty_med_freq_1': angioplastyMedFreq1,
      'angioplasty_med_freq_2': angioplastyMedFreq2,
      'angioplasty_med_freq_3': angioplastyMedFreq3,
      'angioplasty_image_1': angioplastyImage1,
      'angioplasty_image_2': angioplastyImage2,
      'angioplasty_image_3': angioplastyImage3,
      'bypass': bypass,
      'bypass_when': bypassWhen,
      'bypass_on_medicine': bypassOnMedicine,
      'bypass_med_name_1': bypassMedName1,
      'bypass_med_name_2': bypassMedName2,
      'bypass_med_name_3': bypassMedName3,
      'bypass_med_freq_1': bypassMedFreq1,
      'bypass_med_freq_2': bypassMedFreq2,
      'bypass_med_freq_3': bypassMedFreq3,
      'bypass_image_1': bypassImage1,
      'bypass_image_2': bypassImage2,
      'bypass_image_3': bypassImage3,
      'med_allergy': medAllergy,
      'allergy_med_name_1': allergyMedName1,
      'allergy_med_name_2': allergyMedName2,
      'allergy_med_name_3': allergyMedName3,
      'bleeding_tendency': bleedingTendency,
      'other_surgery': otherSurgery,
      'surgery_name_1': surgeryName1,
      'surgery_name_2': surgeryName2,
      'surgery_name_3': surgeryName3,
    };
  }

  factory MedicalFormDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicalFormDetailsModel(
      hypertension: json['hypertension']?.toString() ?? '',
      hypertensionSince: json['hypertension_since']?.toString() ?? '',
      hypertensionMed: json['hypertension_med']?.toString() ?? '',
      hyperMedRegular: json['hyper_med_regular']?.toString() ?? '',
      hypertensionMedName1: json['hypertension_med_name_1']?.toString() ?? '',
      hypertensionMedName2: json['hypertension_med_name_2']?.toString() ?? '',
      hypertensionMedName3: json['hypertension_med_name_3']?.toString() ?? '',
      hypertensionMedFreq1: json['hypertension_med_freq_1']?.toString() ?? '',
      hypertensionMedFreq2: json['hypertension_med_freq_2']?.toString() ?? '',
      hypertensionMedFreq3: json['hypertension_med_freq_3']?.toString() ?? '',
      htnImage1: json['htn_image_1']?.toString() ?? '',
      htnImage2: json['htn_image_2']?.toString() ?? '',
      htnImage3: json['htn_image_3']?.toString() ?? '',
      diabetes: json['diabetes']?.toString() ?? '',
      diabetesSince: json['diabetes_since']?.toString() ?? '',
      diabetesMed: json['diabetes_med']?.toString() ?? '',
      diabetesMedRegular: json['diabetes_med_regular']?.toString() ?? '',
      diabetesMedName1: json['diabetes_med_name_1']?.toString() ?? '',
      diabetesMedName2: json['diabetes_med_name_2']?.toString() ?? '',
      diabetesMedName3: json['diabetes_med_name_3']?.toString() ?? '',
      diabetesMedFreq1: json['diabetes_med_freq_1']?.toString() ?? '',
      diabetesMedFreq2: json['diabetes_med_freq_2']?.toString() ?? '',
      diabetesMedFreq3: json['diabetes_med_freq_3']?.toString() ?? '',
      diabetesImage1: json['diabetes_image_1']?.toString() ?? '',
      diabetesImage2: json['diabetes_image_2']?.toString() ?? '',
      diabetesImage3: json['diabetes_image_3']?.toString() ?? '',
      thyroid: json['thyroid']?.toString() ?? '',
      thyroidSince: json['thyroid_since']?.toString() ?? '',
      thyroidMed: json['thyroid_med']?.toString() ?? '',
      thyroidMedRegular: json['thyroid_med_regular']?.toString() ?? '',
      thyroidMedName1: json['thyroid_med_name_1']?.toString() ?? '',
      thyroidMedName2: json['thyroid_med_name_2']?.toString() ?? '',
      thyroidMedName3: json['thyroid_med_name_3']?.toString() ?? '',
      thyroidMedFreq1: json['thyroid_med_freq_1']?.toString() ?? '',
      thyroidMedFreq2: json['thyroid_med_freq_2']?.toString() ?? '',
      thyroidMedFreq3: json['thyroid_med_freq_3']?.toString() ?? '',
      thyroidImage1: json['thyroid_image_1']?.toString() ?? '',
      thyroidImage2: json['thyroid_image_2']?.toString() ?? '',
      thyroidImage3: json['thyroid_image_3']?.toString() ?? '',
      cholestrol: json['cholestrol']?.toString() ?? '',
      asthma: json['asthma']?.toString() ?? '',
      pregnant: json['pregnant']?.toString() ?? '',
      duringPregnancy: json['during_pregnancy']?.toString() ?? '',
      // Section 2
      heartAttack: json['heart_attack']?.toString() ?? '',
      heartAttackWhen: json['heart_attack_when']?.toString() ?? '',
      heartAttackOnMedicine: json['heart_attack_on_medicine']?.toString() ?? '',
      heartAttackMedName1: json['heart_attack_med_name_1']?.toString() ?? '',
      heartAttackMedName2: json['heart_attack_med_name_2']?.toString() ?? '',
      heartAttackMedName3: json['heart_attack_med_name_3']?.toString() ?? '',
      heartAttackMedFreq1: json['heart_attack_med_freq_1']?.toString() ?? '',
      heartAttackMedFreq2: json['heart_attack_med_freq_2']?.toString() ?? '',
      heartAttackMedFreq3: json['heart_attack_med_freq_3']?.toString() ?? '',
      heartAttackImage1: json['heart_attack_image_1']?.toString() ?? '',
      heartAttackImage2: json['heart_attack_image_2']?.toString() ?? '',
      heartAttackImage3: json['heart_attack_image_3']?.toString() ?? '',
      stroke: json['stroke']?.toString() ?? '',
      strokeWhen: json['stroke_when']?.toString() ?? '',
      strokeOnMedicine: json['stroke_on_medicine']?.toString() ?? '',
      strokeMedName1: json['stroke_med_name_1']?.toString() ?? '',
      strokeMedName2: json['stroke_med_name_2']?.toString() ?? '',
      strokeMedName3: json['stroke_med_name_3']?.toString() ?? '',
      strokeMedFreq1: json['stroke_med_freq_1']?.toString() ?? '',
      strokeMedFreq2: json['stroke_med_freq_2']?.toString() ?? '',
      strokeMedFreq3: json['stroke_med_freq_3']?.toString() ?? '',
      strokeImage1: json['stroke_image_1']?.toString() ?? '',
      strokeImage2: json['stroke_image_2']?.toString() ?? '',
      strokeImage3: json['stroke_image_3']?.toString() ?? '',
      kidneyFailure: json['kidney_failure']?.toString() ?? '',
      kidneyFailureWhen: json['kidney_failure_when']?.toString() ?? '',
      kidneyFailureOnMedicine: json['kidney_failure_on_medicine']?.toString() ?? '',
      kidneyFailureMedName1: json['kidney_failure_med_name_1']?.toString() ?? '',
      kidneyFailureMedName2: json['kidney_failure_med_name_2']?.toString() ?? '',
      kidneyFailureMedName3: json['kidney_failure_med_name_3']?.toString() ?? '',
      kidneyFailureMedFreq1: json['kidney_failure_med_freq_1']?.toString() ?? '',
      kidneyFailureMedFreq2: json['kidney_failure_med_freq_2']?.toString() ?? '',
      kidneyFailureMedFreq3: json['kidney_failure_med_freq_3']?.toString() ?? '',
      kidneyFailImage1: json['kidney_fail_image_1']?.toString() ?? '',
      kidneyFailImage2: json['kidney_fail_image_2']?.toString() ?? '',
      kidneyFailImage3: json['kidney_fail_image_3']?.toString() ?? '',
      angioplasty: json['angioplasty']?.toString() ?? '',
      angioplastyWhen: json['angioplasty_when']?.toString() ?? '',
      angioplastyOnMedicine: json['angioplasty_on_medicine']?.toString() ?? '',
      angioplastyMedName1: json['angioplasty_med_name_1']?.toString() ?? '',
      angioplastyMedName2: json['angioplasty_med_name_2']?.toString() ?? '',
      angioplastyMedName3: json['angioplasty_med_name_3']?.toString() ?? '',
      angioplastyMedFreq1: json['angioplasty_med_freq_1']?.toString() ?? '',
      angioplastyMedFreq2: json['angioplasty_med_freq_2']?.toString() ?? '',
      angioplastyMedFreq3: json['angioplasty_med_freq_3']?.toString() ?? '',
      angioplastyImage1: json['angioplasty_image_1']?.toString() ?? '',
      angioplastyImage2: json['angioplasty_image_2']?.toString() ?? '',
      angioplastyImage3: json['angioplasty_image_3']?.toString() ?? '',
      bypass: json['bypass']?.toString() ?? '',
      bypassWhen: json['bypass_when']?.toString() ?? '',
      bypassOnMedicine: json['bypass_on_medicine']?.toString() ?? '',
      bypassMedName1: json['bypass_med_name_1']?.toString() ?? '',
      bypassMedName2: json['bypass_med_name_2']?.toString() ?? '',
      bypassMedName3: json['bypass_med_name_3']?.toString() ?? '',
      bypassMedFreq1: json['bypass_med_freq_1']?.toString() ?? '',
      bypassMedFreq2: json['bypass_med_freq_2']?.toString() ?? '',
      bypassMedFreq3: json['bypass_med_freq_3']?.toString() ?? '',
      bypassImage1: json['bypass_image_1']?.toString() ?? '',
      bypassImage2: json['bypass_image_2']?.toString() ?? '',
      bypassImage3: json['bypass_image_3']?.toString() ?? '',
      medAllergy: json['med_allergy']?.toString() ?? '',
      allergyMedName1: json['allergy_med_name_1']?.toString() ?? '',
      allergyMedName2: json['allergy_med_name_2']?.toString() ?? '',
      allergyMedName3: json['allergy_med_name_3']?.toString() ?? '',
      bleedingTendency: json['bleeding_tendency']?.toString() ?? '',
      otherSurgery: json['other_surgery']?.toString() ?? '',
      surgeryName1: json['surgery_name_1']?.toString() ?? '',
      surgeryName2: json['surgery_name_2']?.toString() ?? '',
      surgeryName3: json['surgery_name_3']?.toString() ?? '',
    );
  }
}
