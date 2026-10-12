class DischargePatientWebRequest {
  final String admitId;
  final String patientCondition;
  final String gc;
  final String pastHistory;
  final String investigations;
  final String presentComplaints;
  final String systolicBp;
  final String diastolicBp;
  final String pulseRate;
  final String spo2;
  final String cvs;
  final String cvsValue;
  final String rs;
  final String rsValue;
  final String cns;
  final String cnsValue;
  final String pa;
  final String paValue;
  final String vitalsPresentOthers;
  final String volume;
  final String pallor;
  final String icterus;
  final String cyanosis;
  final String dischargeSystolicBp;
  final String dischargeDiastolicBp;
  final String dischargePulseRate;
  final String dischargeSpo2;
  final String dischargeCvs;
  final String dischargeCvsValue;
  final String dischargeRs;
  final String dischargeRsValue;
  final String dischargeCns;
  final String dischargeCnsValue;
  final String dischargePa;
  final String dischargePaValue;
  final String vitalsDischargeOthers;
  final String dischargeVolume;
  final String dischargePallor;
  final String dischargeIcterus;
  final String dischargeCyanosis;
  final String dischargeGc;
  final String ecg;
  final String ecgDetails;
  final String surgicalProcedure;
  final String surgenName;
  final String procedurePerformed;
  final String dischargeAdvice;
  final String followDate;
  final String dischargeType;
  final String courceInHospital;
  final String instituteDoctors;
  final String preparedBy;
  final String dischargeBy;
  final String dischargeById;
  final String isFinalDischarge;
  final String isPrintDraft;

  const DischargePatientWebRequest({
    required this.admitId,
    this.patientCondition = '',
    this.gc = '',
    this.pastHistory = '',
    this.investigations = '',
    this.presentComplaints = '',
    this.systolicBp = '',
    this.diastolicBp = '',
    this.pulseRate = '',
    this.spo2 = '',
    this.cvs = '',
    this.cvsValue = '',
    this.rs = '',
    this.rsValue = '',
    this.cns = '',
    this.cnsValue = '',
    this.pa = '',
    this.paValue = '',
    this.vitalsPresentOthers = '',
    this.volume = '',
    this.pallor = '',
    this.icterus = '',
    this.cyanosis = '',
    this.dischargeSystolicBp = '',
    this.dischargeDiastolicBp = '',
    this.dischargePulseRate = '',
    this.dischargeSpo2 = '',
    this.dischargeCvs = '',
    this.dischargeCvsValue = '',
    this.dischargeRs = '',
    this.dischargeRsValue = '',
    this.dischargeCns = '',
    this.dischargeCnsValue = '',
    this.dischargePa = '',
    this.dischargePaValue = '',
    this.vitalsDischargeOthers = '',
    this.dischargeVolume = '',
    this.dischargePallor = '',
    this.dischargeIcterus = '',
    this.dischargeCyanosis = '',
    this.dischargeGc = '',
    this.ecg = '',
    this.ecgDetails = '',
    this.surgicalProcedure = '',
    this.surgenName = '',
    this.procedurePerformed = '',
    this.dischargeAdvice = '',
    this.followDate = '',
    this.dischargeType = '',
    this.courceInHospital = '',
    this.instituteDoctors = '',
    this.preparedBy = '',
    this.dischargeBy = '',
    this.dischargeById = '',
    this.isFinalDischarge = 'false',
    this.isPrintDraft = 'false',
  });

  Map<String, dynamic> toJson() {
    return {
      'admit_id': admitId,
      'patient_condition': patientCondition,
      'gc': gc,
      'past_history': pastHistory,
      'investigations': investigations,
      'present_complaints': presentComplaints,
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'pulse_rate': pulseRate,
      'spo2': spo2,
      'cvs': cvs,
      'cvs_value': cvsValue,
      'rs': rs,
      'rs_value': rsValue,
      'cns': cns,
      'cns_value': cnsValue,
      'pa': pa,
      'pa_value': paValue,
      'vitals_present_others': vitalsPresentOthers,
      'volume': volume,
      'pallor': pallor,
      'icterus': icterus,
      'cyanosis': cyanosis,
      'discharge_systolic_bp': dischargeSystolicBp,
      'discharge_diastolic_bp': dischargeDiastolicBp,
      'discharge_pulse_rate': dischargePulseRate,
      'discharge_spo2': dischargeSpo2,
      'discharge_cvs': dischargeCvs,
      'discharge_cvs_value': dischargeCvsValue,
      'discharge_rs': dischargeRs,
      'discharge_rs_value': dischargeRsValue,
      'discharge_cns': dischargeCns,
      'discharge_cns_value': dischargeCnsValue,
      'discharge_pa': dischargePa,
      'discharge_pa_value': dischargePaValue,
      'vitals_discharge_others': vitalsDischargeOthers,
      'discharge_volume': dischargeVolume,
      'discharge_pallor': dischargePallor,
      'discharge_icterus': dischargeIcterus,
      'discharge_cyanosis': dischargeCyanosis,
      'discharge_gc': dischargeGc,
      'ecg': ecg,
      'ecg_details': ecgDetails,
      'surgical_procedure': surgicalProcedure,
      'surgen_name': surgenName,
      'procedure_performed': procedurePerformed,
      'discharge_advice': dischargeAdvice,
      'follow_date': followDate,
      'discharge_type': dischargeType,
      'cource_in_hospital': courceInHospital,
      'institute_doctors': instituteDoctors,
      'prepared_by': preparedBy,
      'discharge_by': dischargeBy,
      'discharge_by_id': dischargeById,
      'is_final_discharge': isFinalDischarge,
      'is_print_draft': isPrintDraft,
    };
  }
}
