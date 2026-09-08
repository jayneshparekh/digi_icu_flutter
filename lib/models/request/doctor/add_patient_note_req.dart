class AddPatientNoteReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientNote;

  AddPatientNoteReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'patient_note': patientNote,
    };
  }
}
