class BookAppointmentResponse {
  final String status;
  final String msg;
  final String appointmentId;
  final String defaultFormType;

  BookAppointmentResponse({
    required this.status,
    required this.msg,
    required this.appointmentId,
    required this.defaultFormType,
  });

  factory BookAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return BookAppointmentResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString() ?? '',
      defaultFormType: json['default_form_type']?.toString() ?? '',
    );
  }
}

