class ThemeState {
  bool _isDark;
  bool get isDark => _isDark;
  ThemeState(this._isDark);

  static ThemeState fromJson(dynamic json) => ThemeState(json["isDark"]);

  dynamic toJson() => {'isDark': _isDark};
}

ThemeState getInitThemeState() => ThemeState(false);
