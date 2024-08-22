class Cache {
  static String settings="settings";
  static var _cachedResults = {};

  static set(String key, var data) {
    _cachedResults[key] = data;
  }

  static get(String key) {
    return _cachedResults[key];
  }

  static has(String key) {
    return _cachedResults[key] != null;
  }

  static delete([String key = ""]) {
    if (key.isEmpty) {
      _cachedResults = {};
    } else {
      _cachedResults[key] = null;
    }
  }
}
