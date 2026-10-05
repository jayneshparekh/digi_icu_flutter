class GetRemainCreditListReq {
  final String userId;
  final String userType;

  GetRemainCreditListReq({
    required this.userId,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_type': userType,
    };
  }
}
