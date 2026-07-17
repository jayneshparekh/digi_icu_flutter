class AppointmentSlotsResponse {
  final String status;
  final String msg;
  final List<AppointmentSlotModel> data;

  AppointmentSlotsResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory AppointmentSlotsResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<AppointmentSlotModel> list = dataList != null
        ? dataList.map((i) => AppointmentSlotModel.fromJson(i)).toList()
        : [];

    return AppointmentSlotsResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: list,
    );
  }
}

class AppointmentSlotModel {
  final String id;
  final String timeSlot;

  AppointmentSlotModel({
    required this.id,
    required this.timeSlot,
  });

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotModel(
      id: json['id']?.toString() ?? '',
      timeSlot: json['time_slot']?.toString() ?? '',
    );
  }
}

