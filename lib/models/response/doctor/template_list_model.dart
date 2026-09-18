class TemplatesDetailDataModel {
  final String id;
  final String doctorId;
  final String notes;
  final String advice;
  final String holdingReason;
  final String nickname;
  final String categoryName;
  final String groupName;
  final String brandName;
  final String medicineName;
  final String dose;
  final String medType;
  final String frequency;
  final String days;
  final String type;
  final String created;
  final String visitNo;

  TemplatesDetailDataModel({
    required this.id,
    required this.doctorId,
    required this.notes,
    required this.advice,
    required this.holdingReason,
    required this.nickname,
    required this.categoryName,
    required this.groupName,
    required this.brandName,
    required this.medicineName,
    required this.dose,
    required this.medType,
    required this.frequency,
    required this.days,
    required this.type,
    required this.created,
    required this.visitNo,
  });

  factory TemplatesDetailDataModel.fromJson(Map<String, dynamic> json) {
    return TemplatesDetailDataModel(
      id: json['id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      advice: json['advice']?.toString() ?? '',
      holdingReason: json['holding_reason']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      groupName: json['group_name']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
      medicineName: json['medicine_name']?.toString() ?? '',
      dose: json['dose']?.toString() ?? '',
      medType: json['med_type']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      days: json['days']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      visitNo: json['visit_no']?.toString() ?? '',
    );
  }
}

class TemplatesListModel {
  final List<TemplatesDetailDataModel> data;

  TemplatesListModel({required this.data});

  factory TemplatesListModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return TemplatesListModel(
      data: list.map((e) => TemplatesDetailDataModel.fromJson(e)).toList(),
    );
  }
}
