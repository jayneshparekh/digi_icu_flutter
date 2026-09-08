class AddEventReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String event;
  final String eventDetails;
  final String medicines;
  final String investigations;
  final String saltReduction;
  final String exercise;

  AddEventReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.event,
    required this.eventDetails,
    required this.medicines,
    required this.investigations,
    required this.saltReduction,
    required this.exercise,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'event': event,
      'event_details': eventDetails,
      'medicines': medicines,
      'investigations': investigations,
      'salt_reduction': saltReduction,
      'exercise': exercise,
    };
  }
}
