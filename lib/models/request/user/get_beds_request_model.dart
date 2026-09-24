class GetBedsRequestModel {
  final String admitIn;
  final String instituteId;
  final String name;

  const GetBedsRequestModel({
    required this.admitIn,
    required this.instituteId,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'admit_in': admitIn,
        'institute_id': instituteId,
        'name': name,
      };
}
