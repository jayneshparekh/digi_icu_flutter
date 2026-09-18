class GetBedsModel {
  final String bedNo;

  const GetBedsModel({required this.bedNo});

  factory GetBedsModel.fromJson(Map<String, dynamic> json) {
    return GetBedsModel(
      bedNo: json['bed_no']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'bed_no': bedNo};
}
