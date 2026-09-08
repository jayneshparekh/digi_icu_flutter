class AddBpReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String systolic;
  final String diastolic;

  AddBpReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.systolic,
    required this.diastolic,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'bp_systolic': systolic,
      'bp_diastolic': diastolic,
    };
  }
}
