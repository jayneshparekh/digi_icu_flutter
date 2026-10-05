class AddAmbulanceRes {
  final String status;
  final String msg;
  final String orderId;
  final AddAmbulanceDataRes? data;

  AddAmbulanceRes({
    required this.status,
    required this.msg,
    this.orderId = '',
    this.data,
  });

  factory AddAmbulanceRes.fromJson(Map<String, dynamic> json) {
    return AddAmbulanceRes(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? AddAmbulanceDataRes.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'order_id': orderId,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class AddAmbulanceDataRes {
  final String id;
  final String name;
  final String mhcEmail;
  final String mhcId;
  final String latitude;
  final String longitude;

  AddAmbulanceDataRes({
    required this.id,
    required this.name,
    required this.mhcEmail,
    required this.mhcId,
    required this.latitude,
    required this.longitude,
  });

  factory AddAmbulanceDataRes.fromJson(Map<String, dynamic> json) {
    return AddAmbulanceDataRes(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mhcEmail: json['mhc_email']?.toString() ?? '',
      mhcId: json['mhc_id']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mhc_email': mhcEmail,
      'mhc_id': mhcId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
