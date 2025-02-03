import 'package:flash_note/airtel_money/bloc/home_state.dart';
import 'package:flash_note/airtel_money/repo/airtel_money.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uganda_mobile_money/uganda_mobile_money.dart';

class AirtelMoneyBloc {
  final HomeRepository repository;

  // RxDart BehaviorSubjects for handling state
  final _paymentSubject = BehaviorSubject<HomeState>();
  final _transactionVerifySubject = BehaviorSubject<TransactionState>();

  // Streams for UI to listen
  Stream<HomeState> get paymentStream => _paymentSubject.stream;
  Stream<TransactionState> get transactionStream => _transactionVerifySubject.stream;

  AirtelMoneyBloc(this.repository);

  void makePayment(MomoPayRequest request) {
    _paymentSubject.add(PaymentLoading());

    repository.pay(request).then((response) {
      _paymentSubject.add(PaymentLoaded(response));
    }).catchError((error) {
      _paymentSubject.add(PaymentError(error.toString()));
    });
  }

  void verifyTransaction(String txRef) {
    UgandaMobileMoney client = UgandaMobileMoney(secretKey: "FLWSECK_TEST-f6b33af95b76ca09d8861db4430f30fa-X");

    client.verifyTransaction(txRef).then((status) {
      switch (status) {
        case TransactionStatus.failed:
          _transactionVerifySubject.add(TransactionFailed());
          break;
        case TransactionStatus.pending:
          _transactionVerifySubject.add(TransactionPending());
          break;
        case TransactionStatus.success:
          _transactionVerifySubject.add(TransactionSuccess());
          break;
        default:
          _transactionVerifySubject.add(TransactionUnknown());
      }
    }).catchError((error) {
      _transactionVerifySubject.add(TransactionError(error.toString()));
    });
  }

  void dispose() {
    _paymentSubject.close();
    _transactionVerifySubject.close();
  }
}
