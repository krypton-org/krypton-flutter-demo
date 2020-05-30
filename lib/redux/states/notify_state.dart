enum Severity {
  SECONDARY,
  SUCCESS,
  INFO,
  WARNING,
  DANGER,
}

class Notification {
  String message;
  Severity severity;
  Notification(this.message, this.severity);
}

Notification getInitNotifyState() => null;
