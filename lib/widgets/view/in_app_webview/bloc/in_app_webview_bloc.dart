import 'package:rxdart/rxdart.dart';

class InAppWebviewBloc {
  final BehaviorSubject<int> _pageProgress = BehaviorSubject();

  BehaviorSubject<int> get pageProgress => _pageProgress;

  void setPageProgress(int value) {
    _pageProgress.sink.add(value);
  }

  void dispose() {
    _pageProgress.close();
  }
}
