class MyIpdPatientListRequest {
  final String doctorId;
  final String instituteId;
  final String status;
  final String search;
  final int limit;
  final int start;
  final String sortColumn;
  final String sortDir;

  const MyIpdPatientListRequest({
    required this.doctorId,
    required this.instituteId,
    required this.status,
    this.search = '',
    this.limit = 10,
    this.start = 0,
    this.sortColumn = 'id',
    this.sortDir = 'DESC',
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'institute_id': instituteId,
      'status': status,
      'search': search,
      'limit': limit.toString(),
      'start': start.toString(),
      'sort_column': sortColumn,
      'sort_dir': sortDir,
    };
  }
}
