import 'package:flash_note/networking/model/user.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_state.dart';

class AppReducer {
  static AppState reducer(AppState state, StoreAction action) {
    switch (action.type) {
      case ActionType.ChangeLocale:
        return state.copyWith(selectedLocale: action.data as String);
      case ActionType.SetUser:
        return state.copyWith(user: action.data as User);
      case ActionType.SetToken:
        return state.copyWith(token: action.data as String);
      case ActionType.isOnboardingComplete:
        return state.copyWith(isOnboardingComplete: action.data as bool);
      case ActionType.Reset:
        return state.copyWith(
          token: "",
          isOnboardingComplete: false,
        );
      default:
        return state;
    }
  }
}
