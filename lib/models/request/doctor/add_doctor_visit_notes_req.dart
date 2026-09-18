class AddDoctorVisitNotesReq {
  final String appointmentId;
  final String visitNotes;
  final String homeServiceId;

  AddDoctorVisitNotesReq({
    required this.appointmentId,
    required this.visitNotes,
    required this.homeServiceId,
  });

  Map<String, dynamic> toJson() => {
    'appointment_id': appointmentId,
    'visit_notes': visitNotes,
    'home_service_id': homeServiceId,
  };
}
