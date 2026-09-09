class ApiEndpoints {
  ApiEndpoints._();

  // ==========================================
  // Patient Endpoints
  // ==========================================
  static const String checkPromocode = 'api/v2/Patient/check_promocode';
  static const String getTimeSlotNew = 'api/v2/Patient/get_time_slot_new';
  static const String bookAppointment = 'api/v2/Patient/book_appointment';
  static const String primaryCareForm = 'api/v2/Patient/primary_care_form';
  static const String getSliders = 'api/v2/Patient/get_sliders';
  static const String checkHome = 'api/v2/Patient/check_home';
  static const String lastSymptoms = 'api/v2/Patient/last_symptoms';
  static const String clinicalFormNew = 'api/v2/Patient/clinical_form_new';
  static const String medicalFormNew = 'api/v2/Patient/medical_form_new';
  static const String getDoctorList = 'api/v2/Patient/get_doctor_list';
  static const String checkPaymentStatus = 'api/v2/Patient/check_payment_status';
  static const String patientDetails = 'api/v2/Patient/pt_details';
  static const String quickForm = 'api/v2/Patient/quick_form';
  static const String prescriptionList = 'api/v2/Patient/prescription_list';
  static const String getReport = 'api/v2/Patient/get_reports';
  static const String countReports = 'api/v2/Patient/count_reports';
  static const String uploadReport = 'api/v2/Patient/add_report';
  static const String deleteReport = 'api/v2/Patient/delete_report';
  
  // ==========================================
  // Doctor Endpoints
  // ==========================================
  static const String statuswisePatients = 'api/v2/Doctor/statuswise_patients';
  static const String addRating = 'api/v2/Doctor/add_rating';
  static const String dashboardDetails = 'api/v2/Doctor/dashboard_details';
  static const String confirmConsultPatientPost = 'api/v2/Doctor/confirmation';
  static const String getPatientDiagnosis = 'api/v2/Doctor/get_patient_diagnosis';
  static const String addPatientDiagnosis = 'api/v2/Doctor/add_patient_diagnosis';
  static const String getPatientList = 'api/v2/Doctor/get_patient_list';
  static const String checkDoctorHome = 'api/v2/Doctor/check_doctor_home';
  static const String getMedicalForm = 'api/v2/Doctor/get_medical_form';
  static const String bpGraph = 'api/v2/Doctor/bp_graph';
  static const String sugarGraph = 'api/v2/Doctor/sugar_graph';
  static const String otherGraph = 'api/v2/Doctor/other_graph';
  static const String getMedicines = 'api/v2/Doctor/get_medicines';
  static const String addPatientPrescription = 'api/v2/Doctor/add_patient_prescription';
  static const String getPersonalisedTT = 'api/v2/Doctor/get_personalised_tt';
  static const String addPatientNotes = 'api/v2/Doctor/add_patient_notes';
  static const String addSelfNotes = 'api/v2/Doctor/add_self_notes';
  static const String addEvent = 'api/v2/Doctor/add_event';
  static const String addEcg = 'api/v2/Doctor/add_ecg';
  static const String addBp = 'api/v2/Doctor/add_bp';
  static const String addTmt = 'api/v2/Doctor/add_tmt';
  static const String getPatientNotes = 'api/v2/Doctor/get_patient_notes';
  static const String getSelfNotes = 'api/v2/Doctor/get_self_notes';
  static const String getEventDetails = 'api/v2/Doctor/get_event';
  static const String getTemplates = 'api/v2/Doctor/get_template';
  static const String getEcg = 'api/v2/Doctor/get_ecg';
  static const String getBp = 'api/v2/Doctor/get_bp';
  static const String getTmt = 'api/v2/Doctor/get_tmt';

  // ==========================================
  // Admin Endpoints
  // ==========================================
  static const String patientSignup = 'api/v2/Admin/patient_signup';
  static const String search = 'api/v2/Admin/search';

  // ==========================================
  // User Endpoints
  // ==========================================
  static const String getPackageCategories = 'api/v2/User/get_package_categories';
  static const String signin = 'api/v2/User/signin';
  static const String updateAppointmentStatus = 'api/v2/User/update_appointment_status';
  static const String addEcgFranchiseData = 'api/v2/User/add_ecg_franchise_data';

  // ==========================================
  // Payment Endpoints
  // ==========================================
  static const String getOrder = 'api/v2/Payment/get_order';

  // ==========================================
  // Servingpatient Endpoints
  // ==========================================
  static const String sharePrescription = 'web/Servingpatient/share_prescription';
}
