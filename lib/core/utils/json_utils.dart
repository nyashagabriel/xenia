// ============================================================
// json_utils.dart
// ------------------------------------------------------------
// Core Utility: Safe JSON parsing for Supabase responses.
// ============================================================

class XJson {
  XJson._();

  /// Parse a string safely with an optional fallback.
  static String str(Map<String, dynamic> json, String key, {String fallback = ''}) {
    final v = json[key];
    if (v == null) return fallback;
    return v.toString();
  }

  /// Parse an integer safely with an optional fallback.
  static int integer(Map<String, dynamic> json, String key, {int fallback = 0}) {
    final v = json[key];
    if (v == null) return fallback;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? fallback;
  }

  /// Parse a boolean safely with an optional fallback.
  static bool boolean(Map<String, dynamic> json, String key, {bool fallback = false}) {
    final v = json[key];
    if (v == null) return fallback;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  /// Parse a DateTime safely, returns null on failure.
  static DateTime? dateTimeOrNull(Map<String, dynamic> json, String key) {
    final v = json[key];
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  /// Parse a UUID list safely.
  static List<String> uuidList(Map<String, dynamic> json, String key) {
    final v = json[key];
    if (v == null || v is! List) return [];
    return v.map((e) => e.toString()).toList();
  }
}
