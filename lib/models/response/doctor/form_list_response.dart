class FormListResponse {
  final String status;
  final String msg;
  final List<FormListData> data;

  FormListResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory FormListResponse.fromJson(Map<String, dynamic> json) {
    var listData = <FormListData>[];
    if (json['data'] != null && json['data'] is List) {
      listData = (json['data'] as List)
          .map((item) => FormListData.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return FormListResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: listData,
    );
  }
}

class FormListData {
  final String id;
  final String doctorId;
  final String patientNote;
  final String created;
  final String myselfNote;
  final String forPatient;
  final String forLeader;
  final String appointmentId;
  final String referralNotes;
  final String firstName;
  final String lastName;
  final String visitNotes;

  FormListData({
    required this.id,
    required this.doctorId,
    required this.patientNote,
    required this.created,
    required this.myselfNote,
    required this.forPatient,
    required this.forLeader,
    required this.appointmentId,
    required this.referralNotes,
    required this.firstName,
    required this.lastName,
    required this.visitNotes,
  });

  factory FormListData.fromJson(Map<String, dynamic> json) {
    return FormListData(
      id: json['id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      patientNote: json['patient_note']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      myselfNote: json['myself_note']?.toString() ?? '',
      forPatient: json['for_patient']?.toString() ?? '',
      forLeader: json['for_leader']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString() ?? '',
      referralNotes: json['referral_notes']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      visitNotes: json['visit_notes']?.toString() ?? '',
    );
  }
}
