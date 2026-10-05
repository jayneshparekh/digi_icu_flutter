class GetUserPackageDetailReq {
  final String userId;
  final String userType;
  final String packageType;

  GetUserPackageDetailReq({
    required this.userId,
    required this.userType,
    required this.packageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_type': userType,
      'package_type': packageType,
    };
  }
}
