import 'package:boilerplate/redux/actions/notify_action.dart';
import 'package:boilerplate/redux/states/notify_state.dart';
import 'package:redux/redux.dart';

final Reducer<Notification> notifyReducer = combineReducers<Notification>([
  TypedReducer<Notification, NotifyAction>(notify),
]);

Notification notify(Notification state, NotifyAction action) =>
    action.notification;
