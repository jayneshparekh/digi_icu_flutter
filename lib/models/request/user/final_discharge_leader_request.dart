class FinalDischargeLeaderRequest {
  final String admitId;
  final int pharmacyBillPaidStatus;
  final String pharmacyBillDue;
  final int labBillPaidStatus;
  final String labBillDue;
  final int otherBillPaidStatus;
  final String otherBillDue;
  final String dischargeBy;
  final String dischargeById;

  FinalDischargeLeaderRequest({
    required this.admitId,
    required this.pharmacyBillPaidStatus,
    required this.pharmacyBillDue,
    required this.labBillPaidStatus,
    required this.labBillDue,
    required this.otherBillPaidStatus,
    required this.otherBillDue,
    required this.dischargeBy,
    required this.dischargeById,
  });

  Map<String, dynamic> toMap() {
    return {
      'admit_id': admitId,
      'pharmacy_bill_paid_status': pharmacyBillPaidStatus.toString(),
      'pharmacy_bill_due': pharmacyBillDue,
      'lab_bill_paid_status': labBillPaidStatus.toString(),
      'lab_bill_due': labBillDue,
      'other_bill_paid_status': otherBillPaidStatus.toString(),
      'other_bill_due': otherBillDue,
      'discharge_by': dischargeBy,
      'discharge_by_id': dischargeById,
    };
  }
}
