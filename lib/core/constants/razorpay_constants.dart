class RazorpayConstants {
  RazorpayConstants._();

  // --- Razorpay Environment Toggle ---
  // Set to [true] for live payments, [false] for test mode.
  static const bool useLiveMode = true;

  // --- Test Mode Credentials ---
  static const String testKeyId = 'rzp_test_AbqW6pdN8W1lcO';
  static const String testKeySecret = 'TKujjZNK5uGUpUaswH6zs52K';

  // --- Live Mode Credentials ---
  static const String liveKeyId = 'rzp_live_dhiCoQrpS0leAc';
  static const String liveKeySecret = 'DXLnpmFzgrrFLc0BKYlv1WcN';

  // Returns the active key id based on the environment toggle.
  static String get activeKeyId => useLiveMode ? liveKeyId : testKeyId;

  // --- Payment Config ---
  static const String currency = 'INR';
  static const String companyName = 'Digi ICU';
  static const String companyLogo = '';
  static const String description = 'One Time Consultation Fee';
  static const String prefillNameKey = 'name';
  static const String prefillEmailKey = 'email';
  static const String prefillContactKey = 'contact';
}

