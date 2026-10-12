class IpdInvestigationResponse {
  final String status;
  final String msg;
  final List<IpdInvestigationItem> data;

  const IpdInvestigationResponse({
    this.status = '',
    this.msg = '',
    this.data = const [],
  });

  factory IpdInvestigationResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<IpdInvestigationItem> items = [];
    if (rawList is List) {
      items = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => IpdInvestigationItem.fromJson(e))
          .toList();
    }
    return IpdInvestigationResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      data: items,
    );
  }
}

class IpdInvestigationItem {
  final String id;
  final String testName;
  final String category;
  final String testValue;
  final String fromRange;
  final String toRange;
  final String unitRange;
  final String created;

  const IpdInvestigationItem({
    this.id = '',
    this.testName = '',
    this.category = '',
    this.testValue = '',
    this.fromRange = '',
    this.toRange = '',
    this.unitRange = '',
    this.created = '',
  });

  factory IpdInvestigationItem.fromJson(Map<String, dynamic> json) {
    return IpdInvestigationItem(
      id: json['id']?.toString() ?? '',
      testName: json['test_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      testValue: json['test_value']?.toString() ?? '',
      fromRange: json['from_range']?.toString() ?? '',
      toRange: json['to_range']?.toString() ?? '',
      unitRange: json['unit_range']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
    );
  }
}
