class LoginRequest {
  final String emailId;
  final String password;
  final String token;

  LoginRequest({
    required this.emailId,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {'email_id': emailId, 'password': password, 'token': token};
  }
}

