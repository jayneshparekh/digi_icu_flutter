class GetAllBedsInfoResponse {
  final String status;
  final String? msg;
  final List<PlaceBedInfoItem> data;

  const GetAllBedsInfoResponse({
    required this.status,
    this.msg,
    required this.data,
  });

  factory GetAllBedsInfoResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<PlaceBedInfoItem> items = [];
    if (rawList is List) {
      items = rawList
          .map((item) => PlaceBedInfoItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return GetAllBedsInfoResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString(),
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class PlaceBedInfoItem {
  final String? place;
  final List<BedsNameItem> names;

  const PlaceBedInfoItem({
    this.place,
    required this.names,
  });

  factory PlaceBedInfoItem.fromJson(Map<String, dynamic> json) {
    var rawNames = json['names'];
    List<BedsNameItem> nameItems = [];
    if (rawNames is List) {
      nameItems = rawNames
          .map((item) => BedsNameItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return PlaceBedInfoItem(
      place: json['place']?.toString(),
      names: nameItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'names': names.map((x) => x.toJson()).toList(),
    };
  }
}

class BedsNameItem {
  final String? name;
  final List<String> emptyBeds;

  const BedsNameItem({
    this.name,
    required this.emptyBeds,
  });

  factory BedsNameItem.fromJson(Map<String, dynamic> json) {
    var rawBeds = json['empty_beds'];
    List<String> beds = [];
    if (rawBeds is List) {
      beds = rawBeds.map((e) => e.toString()).toList();
    }
    return BedsNameItem(
      name: json['name']?.toString(),
      emptyBeds: beds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'empty_beds': emptyBeds,
    };
  }
}
