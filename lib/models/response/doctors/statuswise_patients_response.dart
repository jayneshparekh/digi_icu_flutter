class StatuswisePatientsResponse {
  final String status;
  final String msg;
  final List<PatientAppointmentData> data;

  StatuswisePatientsResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory StatuswisePatientsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<PatientAppointmentData> dataList = list != null
        ? list.map((i) => PatientAppointmentData.fromJson(i)).toList()
        : [];
    return StatuswisePatientsResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: dataList,
    );
  }
}

class PatientAppointmentData {
  final String id;
  final String place;
  final String mhcId;
  final String patientId;
  final String firstName;
  final String midName;
  final String lastName;
  final String profilePic;
  final String bookingDate;
  final String gender;
  final String mobileNo;
  final String age;
  final String taluka;
  final String district;
  final String state;
  final String leaderName;
  final String leaderMhcId;
  final String leaderMobile;
  final String clinicalFormStatus;
  final String medicalFormStatus;
  final String doctorVerify;
  final String note;
  final String previousNoteSeen;
  final String holdReason;
  final String referReason;
  final String isRefer;
  final String referralNotes;
  final String referDoctorName;
  final String bookingTime;
  final String appointmentBy;
  final String problem;
  final String speciality;
  final String doctorHomeServiceId;
  final String isAdmitted;
  final String admitStatus;
  final String videoUrl;
  final String qrCode;
  final String instituteName;
  final String meetLink;
  final String jitsiLink;

  PatientAppointmentData({
    required this.id,
    required this.place,
    required this.mhcId,
    required this.patientId,
    required this.firstName,
    required this.midName,
    required this.lastName,
    required this.profilePic,
    required this.bookingDate,
    required this.gender,
    required this.mobileNo,
    required this.age,
    required this.taluka,
    required this.district,
    required this.state,
    required this.leaderName,
    required this.leaderMhcId,
    required this.leaderMobile,
    required this.clinicalFormStatus,
    required this.medicalFormStatus,
    required this.doctorVerify,
    required this.note,
    required this.previousNoteSeen,
    required this.holdReason,
    required this.referReason,
    required this.isRefer,
    required this.referralNotes,
    required this.referDoctorName,
    required this.bookingTime,
    required this.appointmentBy,
    required this.problem,
    required this.speciality,
    required this.doctorHomeServiceId,
    required this.isAdmitted,
    required this.admitStatus,
    required this.videoUrl,
    required this.qrCode,
    required this.instituteName,
    required this.meetLink,
    required this.jitsiLink,
  });

  factory PatientAppointmentData.fromJson(Map<String, dynamic> json) {
    return PatientAppointmentData(
      id: json['id']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      midName: json['mid_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      bookingDate: json['booking_date']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      taluka: json['taluka']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      leaderName: json['leader_name']?.toString() ?? '',
      leaderMhcId: json['leader_mhc_id']?.toString() ?? '',
      leaderMobile: json['leader_mobile']?.toString() ?? '',
      clinicalFormStatus: json['clinical_form_status']?.toString() ?? '',
      medicalFormStatus: json['medical_form_status']?.toString() ?? '',
      doctorVerify: json['doctor_verify']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      previousNoteSeen: json['previous_note_seen']?.toString() ?? '',
      holdReason: json['hold_reason']?.toString() ?? '',
      referReason: json['refer_reason']?.toString() ?? '',
      isRefer: json['is_refer']?.toString() ?? '',
      referralNotes: json['referral_notes']?.toString() ?? '',
      referDoctorName: json['refer_doctor_name']?.toString() ?? '',
      bookingTime: json['booking_time']?.toString() ?? '',
      appointmentBy: json['appointment_by']?.toString() ?? '',
      problem: json['problem']?.toString() ?? '',
      speciality: json['speciality']?.toString() ?? '',
      doctorHomeServiceId: json['doctor_home_service_id']?.toString() ?? '',
      isAdmitted: json['is_admitted']?.toString() ?? '',
      admitStatus: json['admit_status']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      qrCode: json['qr_code']?.toString() ?? '',
      instituteName: json['institute_name']?.toString() ?? '',
      meetLink: json['meet_link']?.toString() ?? '',
      jitsiLink: json['jitsi_link']?.toString() ?? '',
    );
  }
}

