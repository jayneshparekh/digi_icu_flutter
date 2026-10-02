class CommonLabReq {
  final String labId;

  CommonLabReq({required this.labId});

  Map<String, dynamic> toJson() => {'lab_id': labId};
}
