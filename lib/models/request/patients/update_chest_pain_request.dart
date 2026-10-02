class UpdateChestPainRequest {
  final String chestPainId;
  final String score;
  final String acidityPain;
  final String chestRegion;
  final String sufferedPainPast;
  final String heartPain;
  final String pastAttack;
  final String familyAttack;

  UpdateChestPainRequest({
    required this.chestPainId,
    required this.score,
    required this.acidityPain,
    required this.chestRegion,
    required this.sufferedPainPast,
    required this.heartPain,
    required this.pastAttack,
    required this.familyAttack,
  });

  Map<String, dynamic> toJson() {
    return {
      'chest_pain_id': chestPainId,
      'score': score,
      'acidity_pain': acidityPain,
      'chest_region': chestRegion,
      'suffered_pain_past': sufferedPainPast,
      'heart_pain': heartPain,
      'past_attack': pastAttack,
      'family_attack': familyAttack,
    };
  }
}
