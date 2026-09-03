import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/constants/razorpay_constants.dart';

/// Wraps the [Razorpay] SDK and exposes a single [openPayment] method.
/// Consumers provide [onSuccess], [onFailure], and optionally [onExternalWallet]
class RazorpayService {
  late final Razorpay _razorpay;

  // Active callbacks set per-payment so each caller owns the result handling.
  void Function(PaymentSuccessResponse)? _onSuccess;
  void Function(PaymentFailureResponse)? _onFailure;
  void Function(ExternalWalletResponse)? _onExternalWallet;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Opens the Razorpay payment checkout.
  ///
  /// [amountInPaise]  – amount in the smallest currency unit (paise for INR).
  ///   E.g. for ₹200 pass 20000.
  /// [orderId]        – Razorpay order ID returned by `api/v2/Payment/get_order`.
  /// [appName]        – Merchant name returned by the server (shown in checkout).
  /// [appLogo]        – Merchant logo URL returned by the server (shown in checkout).
  /// [contactNumber]  – customer phone number (10-digit).
  /// [email]          – customer email address.
  void openPayment({
    required int amountInPaise,
    required String orderId,
    String appName = RazorpayConstants.companyName,
    String appLogo = '',
    String contactNumber = '',
    String email = '',
    String description = RazorpayConstants.description,
    void Function(PaymentSuccessResponse)? onSuccess,
    void Function(PaymentFailureResponse)? onFailure,
    void Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onExternalWallet = onExternalWallet;

    final options = <String, dynamic>{
      'key': RazorpayConstants.activeKeyId,
      'amount': amountInPaise,
      'currency': RazorpayConstants.currency,
      'name': appName.isNotEmpty ? appName : RazorpayConstants.companyName,
      'description': description,
      'order_id': orderId,
      'send_sms_hash': true,
      'allow_rotation': true,
      'prefill': {
        RazorpayConstants.prefillEmailKey: email,
        RazorpayConstants.prefillContactKey: contactNumber,
      },
      'theme': {'color': '#00897B'},
    };

    if (appLogo.isNotEmpty) {
      options['image'] = appLogo;
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      AppSnackbars.showError('Payment Error', 'Unable to initiate payment. Please try again.');
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

  void _handleFailure(PaymentFailureResponse response) {
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onExternalWallet?.call(response);
  }

  /// Must be called when the owner widget or controller is disposed.
  void dispose() {
    _razorpay.clear();
  }
}

