class PackageCategoriesResponse {
  final String status;
  final String msg;
  final List<PackageCategoryModel> data;

  PackageCategoriesResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory PackageCategoriesResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<PackageCategoryModel> list = dataList != null
        ? dataList.map((i) => PackageCategoryModel.fromJson(i)).toList()
        : [];

    return PackageCategoriesResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: list,
    );
  }
}

class PackageCategoryModel {
  final String id;
  final String image;
  final String name;

  PackageCategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  factory PackageCategoryModel.fromJson(Map<String, dynamic> json) {
    return PackageCategoryModel(
      id: json['id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

