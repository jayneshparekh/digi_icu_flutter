class UpdateUserPackageTrackReq {
  final String patientId;
  final String userId;
  final String userType;
  final String type;
  final String refId;

  UpdateUserPackageTrackReq({
    required this.patientId,
    required this.userId,
    required this.userType,
    required this.type,
    required this.refId,
  });

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'user_id': userId,
      'user_type': userType,
      'type': type,
      'ref_id': refId,
    };
  }
}
