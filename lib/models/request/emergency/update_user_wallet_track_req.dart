class UpdateUserWalletTrackReq {
  final String patientId;
  final String amount;
  final String type;
  final String userId;
  final String userType;
  final String packageId;

  UpdateUserWalletTrackReq({
    required this.patientId,
    required this.amount,
    required this.type,
    required this.userId,
    required this.userType,
    this.packageId = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'amount': amount,
      'type': type,
      'user_id': userId,
      'user_type': userType,
      'package_id': packageId,
    };
  }
}
