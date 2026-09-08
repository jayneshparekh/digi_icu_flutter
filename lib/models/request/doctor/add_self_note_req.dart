class AddSelfNoteReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String selfNote;

  AddSelfNoteReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.selfNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'myself_note': selfNote,
      'self_note': selfNote,
    };
  }
}
