class GetLastPrescriptionDischargeResponse {
  final String status;
  final String msg;
  final List<PrescriptionDischargeItem> data;

  const GetLastPrescriptionDischargeResponse({
    this.status = '',
    this.msg = '',
    this.data = const [],
  });

  factory GetLastPrescriptionDischargeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    var rawList = json['data'];
    List<PrescriptionDischargeItem> items = [];
    if (rawList is List) {
      items = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => PrescriptionDischargeItem.fromJson(e))
          .toList();
    }
    return GetLastPrescriptionDischargeResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: items,
    );
  }
}

class PrescriptionDischargeItem {
  final String id;
  final List<DischargeMedicineItem> medicines;
  final String categoryName;
  final String groupName;
  final String type;
  final String presImage1;
  final String presImage2;
  final String presImage3;
  final String prescribedBy;
  final String prescribedStatus;
  final String brandName;
  final String frequency;
  final String days;
  final String tls;
  final String manualRx;

  const PrescriptionDischargeItem({
    this.id = '',
    this.medicines = const [],
    this.categoryName = '',
    this.groupName = '',
    this.type = '',
    this.presImage1 = '',
    this.presImage2 = '',
    this.presImage3 = '',
    this.prescribedBy = '',
    this.prescribedStatus = '',
    this.brandName = '',
    this.frequency = '',
    this.days = '',
    this.tls = '',
    this.manualRx = '',
  });

  factory PrescriptionDischargeItem.fromJson(Map<String, dynamic> json) {
    var rawMeds = json['medicines'];
    List<DischargeMedicineItem> meds = [];
    if (rawMeds is List) {
      meds = rawMeds
          .whereType<Map<String, dynamic>>()
          .map((e) => DischargeMedicineItem.fromJson(e))
          .toList();
    }
    return PrescriptionDischargeItem(
      id: json['id']?.toString() ?? '',
      medicines: meds,
      categoryName: json['category_name']?.toString() ?? '',
      groupName: json['group_name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      presImage1: json['pres_image_1']?.toString() ?? '',
      presImage2: json['pres_image_2']?.toString() ?? '',
      presImage3: json['pres_image_3']?.toString() ?? '',
      prescribedBy: json['prescribed_by']?.toString() ?? '',
      prescribedStatus: json['prescribed_status']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      days: json['days']?.toString() ?? '',
      tls: json['tls']?.toString() ?? '',
      manualRx: json['manual_rx']?.toString() ?? '',
    );
  }

  bool get isManual =>
      manualRx.isNotEmpty && manualRx != 'null' && manualRx != '<br>';
}

class DischargeMedicineItem {
  final String form;
  final String medicineName;
  final String dose;

  const DischargeMedicineItem({
    this.form = '',
    this.medicineName = '',
    this.dose = '',
  });

  factory DischargeMedicineItem.fromJson(Map<String, dynamic> json) {
    return DischargeMedicineItem(
      form: json['form']?.toString() == 'null'
          ? ''
          : (json['form']?.toString() ?? ''),
      medicineName: json['medicine_name']?.toString() == 'null'
          ? ''
          : (json['medicine_name']?.toString() ?? ''),
      dose: json['dose']?.toString() == 'null'
          ? ''
          : (json['dose']?.toString() ?? ''),
    );
  }
}
