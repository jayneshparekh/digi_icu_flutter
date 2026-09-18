class AddReferralNotesReq {
  final String appointmentId;
  final String referralNotes;

  AddReferralNotesReq({
    required this.appointmentId,
    required this.referralNotes,
  });

  Map<String, dynamic> toJson() => {
    'appointment_id': appointmentId,
    'referral_notes': referralNotes,
  };
}
