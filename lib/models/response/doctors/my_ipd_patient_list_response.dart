class MyIpdPatientListResponse {
  final String status;
  final int recordsTotal;
  final int recordsFiltered;
  final int count;
  final List<MyIpdPatientListItem> data;

  const MyIpdPatientListResponse({
    this.status = '',
    this.recordsTotal = 0,
    this.recordsFiltered = 0,
    this.count = 0,
    this.data = const [],
  });

  factory MyIpdPatientListResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<MyIpdPatientListItem> items = [];
    if (rawList is List) {
      items = rawList
          .whereType<Map<String, dynamic>>()
          .map((item) => MyIpdPatientListItem.fromJson(item))
          .toList();
    }

    return MyIpdPatientListResponse(
      status: json['status']?.toString() ?? '',
      recordsTotal: int.tryParse(json['recordsTotal']?.toString() ?? '0') ?? 0,
      recordsFiltered:
          int.tryParse(json['recordsFiltered']?.toString() ?? '0') ?? 0,
      count: int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      data: items,
    );
  }
}

class MyIpdPatientListItem {
  final String admitId;
  final String patientId;
  final String appointmentId;
  final String doctorId;
  final String instituteId;
  final String patientName;
  final String mhcId;
  final String ipdId;
  final String mobileNo;
  final String age;
  final String gender;
  final String status;
  final String instituteName;
  final String profilePic;
  final String qrCode;
  final String created;
  final String doctorName;
  final String diagnosis;
  final String currentPlace;
  final String dischargeSummary;
  final List<ActiveStaff> activeStaff;
  final String consultantName;
  final String consultantMobile;
  final String preparedBy;
  final String draftDate;

  const MyIpdPatientListItem({
    this.admitId = '',
    this.patientId = '',
    this.appointmentId = '',
    this.doctorId = '',
    this.instituteId = '',
    this.patientName = '',
    this.mhcId = '',
    this.ipdId = '',
    this.mobileNo = '',
    this.age = '',
    this.gender = '',
    this.status = '',
    this.instituteName = '',
    this.profilePic = '',
    this.qrCode = '',
    this.created = '',
    this.doctorName = '',
    this.diagnosis = '',
    this.currentPlace = '',
    this.dischargeSummary = '',
    this.activeStaff = const [],
    this.consultantName = '',
    this.consultantMobile = '',
    this.preparedBy = '',
    this.draftDate = '',
  });

  factory MyIpdPatientListItem.fromJson(Map<String, dynamic> json) {
    var rawStaff = json['active_staff'];
    List<ActiveStaff> staffList = [];
    if (rawStaff is List) {
      staffList = rawStaff
          .whereType<Map<String, dynamic>>()
          .map((item) => ActiveStaff.fromJson(item))
          .toList();
    }

    return MyIpdPatientListItem(
      admitId: json['admit_id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      instituteId: json['institute_id']?.toString() ?? '',
      patientName: json['patient_name']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      ipdId: json['ipd_id']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      instituteName: json['institute_name']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      qrCode: json['qr_code']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      currentPlace: json['current_place']?.toString() ?? '',
      dischargeSummary: json['discharge_summary']?.toString() ?? '',
      activeStaff: staffList,
      consultantName: json['consultant_name']?.toString() ?? '',
      consultantMobile: json['consultant_mobile']?.toString() ?? '',
      preparedBy: json['prepared_by']?.toString() ?? '',
      draftDate: json['draft_date']?.toString() ?? '',
    );
  }
}

class ActiveStaff {
  final String role;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String loginTime;

  const ActiveStaff({
    this.role = '',
    this.firstName = '',
    this.lastName = '',
    this.mobileNo = '',
    this.loginTime = '',
  });

  factory ActiveStaff.fromJson(Map<String, dynamic> json) {
    return ActiveStaff(
      role: json['role']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      loginTime: json['login_time']?.toString() ?? '',
    );
  }
}
