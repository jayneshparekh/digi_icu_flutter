class AdmitPlaceModel {
  final String name;

  const AdmitPlaceModel({required this.name});

  factory AdmitPlaceModel.fromJson(Map<String, dynamic> json) {
    return AdmitPlaceModel(
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name};
}
