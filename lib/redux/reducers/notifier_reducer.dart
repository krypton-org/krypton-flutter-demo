import 'package:boilerplate/redux/states/notify_state.dart';
import 'package:redux/redux.dart';

class NotifyAction {
  Notification notification;
  NotifyAction(this.notification);
}

final Reducer<Notification> notifyReducer = combineReducers<Notification>([
  TypedReducer<Notification, NotifyAction>(notify),
]);

Notification notify(Notification state, NotifyAction action) =>
    action.notification;
