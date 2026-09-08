class AddEcgReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String ecgRhythm;
  final String sv2Rv5;
  final String stSegment;
  final String stSegmentLevel;
  final String ecgImpression;

  AddEcgReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.ecgRhythm,
    required this.sv2Rv5,
    required this.stSegment,
    required this.stSegmentLevel,
    required this.ecgImpression,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'ecg_rhythm': ecgRhythm,
      'sv2_rv5': sv2Rv5,
      'st_segment': stSegment,
      'st_segment_level': stSegmentLevel,
      'ecg_impression': ecgImpression,
    };
  }
}
