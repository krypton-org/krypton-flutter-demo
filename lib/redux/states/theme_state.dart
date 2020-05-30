class ThemeState {
  bool _isDark;
  bool get isDark => _isDark;
  ThemeState(this._isDark);
}

ThemeState getInitThemeState() => ThemeState(false);
