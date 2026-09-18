class ChangeAppointmentStatusReq {
  final String appointmentId;
  final String status;
  final String holdReason;
  final String patientId;

  ChangeAppointmentStatusReq({
    required this.appointmentId,
    required this.status,
    required this.holdReason,
    required this.patientId,
  });

  Map<String, dynamic> toJson() => {
    'appointment_id': appointmentId,
    'status': status,
    'hold_reason': holdReason,
    'patient_id': patientId,
  };
}
