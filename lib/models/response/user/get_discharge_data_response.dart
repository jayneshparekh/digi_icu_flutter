class GetDischargeDataResponse {
  final String status;
  final String msg;
  final DischargeData? data;

  const GetDischargeDataResponse({
    this.status = '',
    this.msg = '',
    this.data,
  });

  factory GetDischargeDataResponse.fromJson(Map<String, dynamic> json) {
    return GetDischargeDataResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? DischargeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DischargeData {
  final String id;
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
  final String dischargePath;
  final String created;
  final String updated;

  const DischargeData({
    this.id = '',
    this.admitId = '',
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
    this.dischargePath = '',
    this.created = '',
    this.updated = '',
  });

  factory DischargeData.fromJson(Map<String, dynamic> json) {
    return DischargeData(
      id: json['id']?.toString() ?? '',
      admitId: json['admit_id']?.toString() ?? '',
      patientCondition: json['patient_condition']?.toString() ?? '',
      gc: json['gc']?.toString() ?? '',
      pastHistory: json['past_history']?.toString() ?? '',
      investigations: json['investigations']?.toString() ?? '',
      presentComplaints: json['present_complaints']?.toString() ?? '',
      systolicBp: json['systolic_bp']?.toString() ?? '',
      diastolicBp: json['diastolic_bp']?.toString() ?? '',
      pulseRate: json['pulse_rate']?.toString() ?? '',
      spo2: json['spo2']?.toString() ?? '',
      cvs: json['cvs']?.toString() ?? '',
      cvsValue: json['cvs_value']?.toString() ?? '',
      rs: json['rs']?.toString() ?? '',
      rsValue: json['rs_value']?.toString() ?? '',
      cns: json['cns']?.toString() ?? '',
      cnsValue: json['cns_value']?.toString() ?? '',
      pa: json['pa']?.toString() ?? '',
      paValue: json['pa_value']?.toString() ?? '',
      vitalsPresentOthers: json['vitals_present_others']?.toString() ?? '',
      volume: json['volume']?.toString() ?? '',
      pallor: json['pallor']?.toString() ?? '',
      icterus: json['icterus']?.toString() ?? '',
      cyanosis: json['cyanosis']?.toString() ?? '',
      dischargeSystolicBp: json['discharge_systolic_bp']?.toString() ?? '',
      dischargeDiastolicBp: json['discharge_diastolic_bp']?.toString() ?? '',
      dischargePulseRate: json['discharge_pulse_rate']?.toString() ?? '',
      dischargeSpo2: json['discharge_spo2']?.toString() ?? '',
      dischargeCvs: json['discharge_cvs']?.toString() ?? '',
      dischargeCvsValue: json['discharge_cvs_value']?.toString() ?? '',
      dischargeRs: json['discharge_rs']?.toString() ?? '',
      dischargeRsValue: json['discharge_rs_value']?.toString() ?? '',
      dischargeCns: json['discharge_cns']?.toString() ?? '',
      dischargeCnsValue: json['discharge_cns_value']?.toString() ?? '',
      dischargePa: json['discharge_pa']?.toString() ?? '',
      dischargePaValue: json['discharge_pa_value']?.toString() ?? '',
      vitalsDischargeOthers: json['vitals_discharge_others']?.toString() ?? '',
      dischargeVolume: json['discharge_volume']?.toString() ?? '',
      dischargePallor: json['discharge_pallor']?.toString() ?? '',
      dischargeIcterus: json['discharge_icterus']?.toString() ?? '',
      dischargeCyanosis: json['discharge_cyanosis']?.toString() ?? '',
      dischargeGc: json['discharge_gc']?.toString() ?? '',
      ecg: json['ecg']?.toString() ?? '',
      ecgDetails: json['ecg_details']?.toString() ?? '',
      surgicalProcedure: json['surgical_procedure']?.toString() ?? '',
      surgenName: json['surgen_name']?.toString() ?? '',
      procedurePerformed: json['procedure_performed']?.toString() ?? '',
      dischargeAdvice: json['discharge_advice']?.toString() ?? '',
      followDate: json['follow_date']?.toString() ?? '',
      dischargeType: json['discharge_type']?.toString() ?? '',
      courceInHospital: json['cource_in_hospital']?.toString() ?? '',
      instituteDoctors: json['institute_doctors']?.toString() ?? '',
      preparedBy: json['prepared_by']?.toString() ?? '',
      dischargePath: json['discharge_path']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      updated: json['updated']?.toString() ?? '',
    );
  }
}
