import 'package:rxdart/rxdart.dart';

class OnboardingBloc {
  final _totalPages = 3;

  final BehaviorSubject<int> _currentPage = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<int> get currentPage => _currentPage;

  void updatePage(int page) {
    if (page >= 0 && page < _totalPages) {
      _currentPage.add(page);
    }
  }

  void dispose() {
    _currentPage.close();
  }
}

