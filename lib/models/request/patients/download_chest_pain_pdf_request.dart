class DownloadChestPainPdfRequest {
  final String chestPainId;

  DownloadChestPainPdfRequest({required this.chestPainId});

  Map<String, dynamic> toJson() {
    return {'chestpaid_id': chestPainId};
  }
}
