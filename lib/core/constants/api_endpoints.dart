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
  static const String checkPaymentStatus =
      'api/v2/Patient/check_payment_status';
  static const String patientDetails = 'api/v2/Patient/pt_details';
  static const String quickForm = 'api/v2/Patient/quick_form';
  static const String prescriptionList = 'api/v2/Patient/prescription_list';
  static const String getReport = 'api/v2/Patient/get_reports';
  static const String countReports = 'api/v2/Patient/count_reports';
  static const String uploadReport = 'api/v2/Patient/add_report';
  static const String deleteReport = 'api/v2/Patient/delete_report';
  static const String addChestPain = 'api/v2/Patient/add_chest_pain';
  static const String updateChestPain = 'api/v2/Patient/update_chest_pain';
  static const String chestPainPdf = 'api/v2/Patient/chestpain_pdf';
  static const String addAmbulanceService =
      'api/v2/Patient/add_ambulance_service';

  // ==========================================
  // Doctor Endpoints
  // ==========================================
  static const String statuswisePatients = 'api/v2/Doctor/statuswise_patients';
  static const String getDefault = 'api/v2/Doctor/get_default';
  static const String getNoOfPatients = 'api/v2/Doctor/get_no_of_patients';
  static const String addRating = 'api/v2/Doctor/add_rating';
  static const String dashboardDetails = 'api/v2/Doctor/dashboard_details';
  static const String confirmConsultPatientPost = 'api/v2/Doctor/confirmation';
  static const String getPatientDiagnosis =
      'api/v2/Doctor/get_patient_diagnosis';
  static const String addPatientDiagnosis =
      'api/v2/Doctor/add_patient_diagnosis';
  static const String getPatientList = 'api/v2/Doctor/get_patient_list';
  static const String checkDoctorHome = 'api/v2/Doctor/check_doctor_home';
  static const String getMedicalForm = 'api/v2/Doctor/get_medical_form';
  static const String bpGraph = 'api/v2/Doctor/bp_graph';
  static const String sugarGraph = 'api/v2/Doctor/sugar_graph';
  static const String otherGraph = 'api/v2/Doctor/other_graph';
  static const String getMedicines = 'api/v2/Doctor/get_medicines';
  static const String addPatientPrescription =
      'api/v2/Doctor/add_patient_prescription';
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
  static const String quickFormsList = 'api/v2/Doctor/quick_forms_list';
  static const String getQuickForm = 'api/v2/Doctor/get_quick_form';
  static const String updateQuickForm = 'api/v2/Doctor/update_quick_form';
  static const String holdQuickAppointment =
      'api/v2/Doctor/hold_quick_appointment';
  static const String addReferralNotes = 'api/v2/Doctor/add_referral_notes';
  static const String addHomeVisitNotes = 'api/v2/Doctor/add_home_visit_notes';
  static const String medicalFormsList = 'api/v2/Doctor/medical_forms_list';
  static const String updateMedicalForm = 'api/v2/Doctor/update_medical_form';
  static const String clinicalFormsList = 'api/v2/Doctor/clinical_forms_list';
  static const String getClinicalForm = 'api/v2/Doctor/get_clinical_form';
  static const String updateClinicalForm = 'api/v2/Doctor/update_clinical_form';
  static const String serveQuickAppointment =
      'api/v2/Doctor/serve_quick_appointment';
  static const String serveAndNextQuickAppointment =
      'api/v2/Doctor/serve_and_next_quick_appointment';
  static const String getInstituteAmenities =
      'api/v2/Doctor/get_institute_amenities';
  static const String checkAdmitPrescription =
      'api/v2/Doctor/check_admit_discharge_prescription';
  static const String getLabIdApiPrefix =
      'web/doctorweb/get_lab_id_api/institute_lab/institute_id/is_default/';

  // ==========================================
  // Admin Endpoints
  // ==========================================
  static const String patientSignup = 'api/v2/Admin/patient_signup';
  static const String search = 'api/v2/Admin/search';
  static const String getDoctorListAdmin = 'api/v2/Admin/get_doctor_list';
  static const String updateUserPackageTrack =
      'api/v2/Admin/update_user_package_track';

  // ==========================================
  // Lab Endpoints
  // ==========================================
  static const String getLabOwnDoctors = 'api/v2/Lab/get_lab_own_doctors';

  // ==========================================
  // User Endpoints
  // ==========================================
  static const String getPackageCategories =
      'api/v2/User/get_package_categories';
  static const String getUserPackageDetails =
      'api/v2/User/get_user_package_details';
  static const String getRemainingCreditList =
      'api/v2/User/get_remaining_credit_list';
  static const String updateUserWalletTrack =
      'api/v2/User/update_user_wallet_track';
  static const String signin = 'api/v2/User/signin';
  static const String updateAppointmentStatus =
      'api/v2/User/update_appointment_status';
  static const String addEcgFranchiseData =
      'api/v2/User/add_ecg_franchise_data';
  static const String whereAdmit = 'api/v2/User/where_admit';
  static const String getBeds = 'api/v2/User/get_beds';
  static const String getInstitute = 'api/v2/User/get_institute';
  static const String getDischargeData = 'api/v2/User/get_discharge_data';
  static const String getInvestigationsForIpdAdmit =
      'api/v2/User/get_investigations_for_ipd_admit';
  static const String getLastPrescriptionForDischarge =
      'api/v2/User/get_last_prescription_for_discharge';
  static const String deleteDischargePrescription =
      'api/v2/User/delete_discharge_prescription';
  static const String addDischargePrescription =
      'api/v2/User/add_discharge_prescription';
  static const String updateManualRx = 'api/v2/User/update_manual_rx';
  static const String dischargePatientWeb =
      'api/v2/User/discharge_patient_web';
  static const String uploadDischargeSummaryPdf =
      'api/v2/User/upload_discharge_summary_pdf';
  static const String finalDischargeLeader =
      'api/v2/User/final_discharge_leader';

  // ==========================================
  // Payment Endpoints
  // ==========================================
  static const String getOrder = 'api/v2/Payment/get_order';
  static const String verifySignature = 'api/v2/Payment/verify_signature';

  // ==========================================
  // Servingpatient Endpoints
  // ==========================================
  static const String sharePrescription =
      'web/Servingpatient/share_prescription';

  // ==========================================
  // IPDPatient Endpoints
  // ==========================================
  static const String addAdmitPatientRequest =
      'web/IPDPatients/add_admit_patient_request';
  static const String ipdPatientsList = 'web/IPDPatients/ipd_patients_list';
  static const String requestDischarge = 'web/IPDPatients/request_discharge';
  static const String getAdmitRequestsByStatus =
      'web/IPDPatients/get_admit_requests_by_status';
  static const String markAdmitPatientRequestNotificationsAsRead =
      'web/IPDPatients/mark_admit_patient_request_notifications_as_read';
  static const String getDischargeRequestedPatients =
      'web/IPDPatients/ipd_patients_discharge_request_list';
  static const String markDischargePatientRequestNotificationsAsRead =
      'web/IPDPatients/mark_discharge_patient_request_notifications_as_read';

  // ==========================================
  // Leader Endpoints
  // ==========================================
  static const String checkLeaderHome = 'api/v2/Leader/check_leader_home';
  static const String getLeaderPatientList = 'api/v2/Leader/get_patient_list';
  static const String getAllBedsInfo = 'api/v2/Leader/get_all_beds_info';
  static const String changePatientBed = 'api/v2/Leader/change_patient_bed';

  // ==========================================
  // Institute Endpoints
  // ==========================================
  static const String admitPatientFromWeb =
      'api/v2/Institute/admit_patient_from_web';
}
