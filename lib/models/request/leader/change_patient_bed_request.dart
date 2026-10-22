class ChangePatientBedRequest {
  final String instituteId;
  final String admitId;
  final String patientId;
  final String admitIn;
  final String name;
  final String bedNo;
  final String oldPlace;
  final String oldName;
  final String oldBedNo;

  const ChangePatientBedRequest({
    required this.instituteId,
    required this.admitId,
    required this.patientId,
    required this.admitIn,
    required this.name,
    required this.bedNo,
    required this.oldPlace,
    required this.oldName,
    required this.oldBedNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'institute_id': instituteId,
      'admit_id': admitId,
      'patient_id': patientId,
      'admit_in': admitIn,
      'name': name,
      'bed_no': bedNo,
      'old_place': oldPlace,
      'old_name': oldName,
      'old_bed_no': oldBedNo,
    };
  }
}
