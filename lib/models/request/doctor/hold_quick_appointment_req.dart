class HoldQuickAppointmentReq {
  final String patientId;
  final String remarks;
  final String userId;
  final String userType;

  HoldQuickAppointmentReq({
    required this.patientId,
    required this.remarks,
    required this.userId,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'remarks': remarks,
    'user_id': userId,
    'user_type': userType,
  };
}
