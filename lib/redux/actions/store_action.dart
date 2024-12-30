class StoreAction<T> {
  ActionType type;
  T data;

  StoreAction({required this.type, required this.data});
}

enum ActionType { ChangeLocale, SetUser, SetToken, Reset }
