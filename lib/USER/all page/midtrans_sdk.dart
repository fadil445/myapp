
class MidtransSdk {
  final String clientKey;
  final String environment;

  MidtransSdk({
    required this.clientKey,
    this.environment = 'sandbox', // Default to sandbox environment
  }) {
    // Inisialisasi Midtrans SDK
    _initMidtrans();
  }

  // Fungsi untuk menginisialisasi Midtrans SDK
  void _initMidtrans() {
    // Jika Anda memiliki library atau SDK khusus, inisialisasikan di sini.
    // Contoh (hypothetical):
    // SomeMidtransLibrary.initialize(clientKey, isSandbox: environment == 'sandbox');
    print('Midtrans SDK initialized with clientKey: $clientKey in ${environment} mode');
  }

  // Fungsi untuk memulai pembayaran
  void startPayment({
    required String token,
    required Function(TransactionResult) onPaymentResult,
    required dynamic Midtrans,
  }) {
    // Mulai proses pembayaran
    Midtrans.pay(token).then((result) {
      onPaymentResult(result);
    }).catchError((error) {
      // Tangani error jika ada
      print('Payment Error: $error');
      onPaymentResult(TransactionResult.failure(errorMessage: error.toString()));
    });
  }
}

// Class untuk menangani hasil transaksi
class TransactionResult {
  final bool isTransactionSuccessful;
  final bool isTransactionCancelled;
  final String? errorMessage;

  TransactionResult({
    required this.isTransactionSuccessful,
    required this.isTransactionCancelled,
    this.errorMessage,
  });

  // Factory untuk hasil sukses
  factory TransactionResult.success() {
    return TransactionResult(
      isTransactionSuccessful: true,
      isTransactionCancelled: false,
    );
  }

  // Factory untuk hasil kegagalan
  factory TransactionResult.failure({String? errorMessage}) {
    return TransactionResult(
      isTransactionSuccessful: false,
      isTransactionCancelled: false,
      errorMessage: errorMessage,
    );
  }

  // Factory untuk hasil dibatalkan
  factory TransactionResult.cancelled() {
    return TransactionResult(
      isTransactionSuccessful: false,
      isTransactionCancelled: true,
    );
  }
}
