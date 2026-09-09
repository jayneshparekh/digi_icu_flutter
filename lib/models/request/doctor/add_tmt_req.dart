class AddTmtReq {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String tmtDetails;
  final String mets;
  final String metOthers;

  AddTmtReq({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.tmtDetails,
    required this.mets,
    required this.metOthers,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'result': tmtDetails,
      'mets': mets,
      'others': metOthers,
    };
  }
}
