class AdmitPlaceRequestModel {
  final String admitIn;
  final String instituteId;

  const AdmitPlaceRequestModel({
    required this.admitIn,
    required this.instituteId,
  });

  Map<String, dynamic> toJson() => {
        'admit_in': admitIn,
        'institute_id': instituteId,
      };
}
