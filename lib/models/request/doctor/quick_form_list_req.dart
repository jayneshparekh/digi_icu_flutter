class QuickFormListReq {
  final String patientId;

  QuickFormListReq({required this.patientId});

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
    };
  }
}
