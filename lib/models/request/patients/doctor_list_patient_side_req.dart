class DoctorListPatientSideReq {
  final int page;
  final String patientId;
  final String day;
  final String time;
  final String speciality;

  DoctorListPatientSideReq({
    required this.page,
    required this.patientId,
    required this.day,
    required this.time,
    required this.speciality,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'patient_id': patientId,
      'day': day,
      'time': time,
      'speciality': speciality,
    };
  }
}

