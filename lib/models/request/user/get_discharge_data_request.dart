class GetDischargeDataRequest {
  final String admitId;

  const GetDischargeDataRequest({
    required this.admitId,
  });

  Map<String, dynamic> toJson() {
    return {
      'admit_id': admitId,
    };
  }
}
