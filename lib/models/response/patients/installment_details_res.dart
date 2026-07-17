class InstallmentDetailsRes {
  final String status;
  final String installments;
  final String warningMsg;
  final String thirdInstallmentDate;
  final String thirdInstallmentAmount;
  final String secondInstallmentDate;
  final String secondInstallmentAmount;
  final String packageName;
  final String packageId;
  final String paymentReferenceId;

  InstallmentDetailsRes({
    required this.status,
    required this.installments,
    required this.warningMsg,
    required this.thirdInstallmentDate,
    required this.thirdInstallmentAmount,
    required this.secondInstallmentDate,
    required this.secondInstallmentAmount,
    required this.packageName,
    required this.packageId,
    required this.paymentReferenceId,
  });

  factory InstallmentDetailsRes.fromJson(Map<String, dynamic> json) {
    return InstallmentDetailsRes(
      status: json['status']?.toString() ?? '',
      installments: json['installments']?.toString() ?? '',
      warningMsg: json['warning_msg']?.toString() ?? '',
      thirdInstallmentDate: json['third_installment_date']?.toString() ?? '',
      thirdInstallmentAmount: json['third_installment_amount']?.toString() ?? '',
      secondInstallmentDate: json['second_installment_date']?.toString() ?? '',
      secondInstallmentAmount: json['second_installment_amount']?.toString() ?? '',
      packageName: json['package_name']?.toString() ?? '',
      packageId: json['package_id']?.toString() ?? '',
      paymentReferenceId: json['payment_reference_id']?.toString() ?? '',
    );
  }
}

