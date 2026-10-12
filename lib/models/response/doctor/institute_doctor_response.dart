class InstituteDoctorResponse {
  final String status;
  final String msg;
  final int count;
  final List<InstituteDoctorItem> data;

  const InstituteDoctorResponse({
    this.status = '',
    this.msg = '',
    this.count = 0,
    this.data = const [],
  });

  factory InstituteDoctorResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<InstituteDoctorItem> items = [];
    if (rawList is List) {
      items = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => InstituteDoctorItem.fromJson(e))
          .toList();
    }
    return InstituteDoctorResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
      data: items,
    );
  }
}

class InstituteDoctorItem {
  final String id;
  final String firstName;
  final String midName;
  final String lastName;
  final String fullName;
  final String degrees;
  final String mobileNo;

  const InstituteDoctorItem({
    this.id = '',
    this.firstName = '',
    this.midName = '',
    this.lastName = '',
    this.fullName = '',
    this.degrees = '',
    this.mobileNo = '',
  });

  factory InstituteDoctorItem.fromJson(Map<String, dynamic> json) {
    return InstituteDoctorItem(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      degrees: json['degrees']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
    );
  }

  String get displayName {
    if (fullName.isNotEmpty && fullName != 'null') {
      return fullName.startsWith('Dr.') ? fullName : 'Dr. $fullName';
    }
    final name = '$firstName $lastName'.trim();
    if (name.isNotEmpty) {
      return name.startsWith('Dr.') ? name : 'Dr. $name';
    }
    return 'Dr.';
  }
}
