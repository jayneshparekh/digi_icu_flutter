class GetQuickFormReq {
  final String formId;

  GetQuickFormReq({required this.formId});

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
    };
  }
}
