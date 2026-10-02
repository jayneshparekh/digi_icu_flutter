class AddChestPainRequest {
  final String patientId;
  final String forWhom;
  final String fullName;
  final String age;
  final String gender;
  final String pastHistory;
  final String kindOfPain;
  final String location;
  final String painGoing;
  final String duration;
  final String symptoms;
  final String exertion;
  final String startedPain;
  final String latitude;
  final String longitude;
  final String patientLocation;

  AddChestPainRequest({
    required this.patientId,
    required this.forWhom,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.pastHistory,
    required this.kindOfPain,
    required this.location,
    required this.painGoing,
    required this.duration,
    required this.symptoms,
    required this.exertion,
    this.startedPain = '',
    this.latitude = '',
    this.longitude = '',
    this.patientLocation = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'for_whom': forWhom,
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'past_history': pastHistory,
      'kind_of_pain': kindOfPain,
      'location': location,
      'pain_going': painGoing,
      'duration': duration,
      'symptoms': symptoms,
      'exertion': exertion,
      'started_pain': startedPain,
      'latitude': latitude,
      'longitude': longitude,
      'patient_location': patientLocation,
    };
  }
}
