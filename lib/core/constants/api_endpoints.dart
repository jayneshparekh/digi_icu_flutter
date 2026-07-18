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

  // ==========================================
  // Payment Endpoints
  // ==========================================
  static const String getOrder = 'api/v2/Payment/get_order';
}
