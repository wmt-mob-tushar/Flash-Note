import 'package:flash_note/networking/model/user.dart';
import 'package:flash_note/redux/actions/store_action.dart';
import 'package:flash_note/redux/app_state.dart';

class AppReducer {
  static AppState reducer(AppState state, StoreAction action) {
    switch (action.type) {
      case ActionType.ChangeLocale:
        return state.copyWith(selectedLocale: action.data as String);
      case ActionType.SetUser:
        return state.copyWith(user: action.data as Wrapper<User>);
      case ActionType.SetToken:
        return state.copyWith(token: action.data as Wrapper<String>);
      case ActionType.Reset:
        return state.copyWith(
          token: Wrapper.value(null),
          user: Wrapper.value(null),
        );
      default:
        return state;
    }
  }
}
