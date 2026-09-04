class BPGraphResponse {
  final String? status;
  final String? msg;
  final List<BPGraphData>? data;
  final TargetBp? targetBp;

  BPGraphResponse({
    this.status,
    this.msg,
    this.data,
    this.targetBp,
  });

  factory BPGraphResponse.fromJson(Map<String, dynamic> json) {
    return BPGraphResponse(
      status: json['status'] as String?,
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BPGraphData.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetBp: json['target_bp'] != null
          ? TargetBp.fromJson(json['target_bp'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BPGraphData {
  final int systolicBp;
  final int diastolicBp;
  final String created;

  BPGraphData({
    required this.systolicBp,
    required this.diastolicBp,
    required this.created,
  });

  factory BPGraphData.fromJson(Map<String, dynamic> json) {
    return BPGraphData(
      systolicBp: _parseInt(json['systolic_bp']),
      diastolicBp: _parseInt(json['diastolic_bp']),
      created: (json['created'] ?? '').toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class TargetBp {
  final int targetBpSystolic;
  final int targetBpDiastolic;
  final String created;

  TargetBp({
    required this.targetBpSystolic,
    required this.targetBpDiastolic,
    required this.created,
  });

  factory TargetBp.fromJson(Map<String, dynamic> json) {
    return TargetBp(
      targetBpSystolic: _parseInt(json['target_bp_systolic']),
      targetBpDiastolic: _parseInt(json['target_bp_diastolic']),
      created: (json['created'] ?? '').toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
