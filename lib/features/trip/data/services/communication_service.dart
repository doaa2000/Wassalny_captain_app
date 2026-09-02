import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper around url_launcher for passenger communication (call / SMS).
/// Keeps the url_launcher import isolated to the data layer so presentation
/// widgets never touch the package directly.
class CommunicationService {
  const CommunicationService();

  /// Dials the passenger's phone number. Returns false if the URL could not
  /// be launched (no dialer / permission).
  Future<bool> callPassenger(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: _sanitize(phone));
    return _launch(uri);
  }

  /// Opens the SMS composer pre-addressed to the passenger. [body] is an
  /// optional pre-filled message.
  Future<bool> messagePassenger(String phone, {String? body}) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: _sanitize(phone),
      queryParameters: body == null ? null : {'body': body},
    );
    return _launch(uri);
  }

  Future<bool> _launch(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Strips everything except digits and the leading '+' so tel:/sms: URIs are
  /// well-formed regardless of how the number was stored.
  static String _sanitize(String phone) {
    final String trimmed = phone.trim();
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < trimmed.length; i++) {
      final String c = trimmed[i];
      if (c == '+' && buf.isEmpty) {
        buf.write(c); // keep leading plus
      } else if (RegExp(r'\d').hasMatch(c)) {
        buf.write(c);
      }
    }
    return buf.toString();
  }
}
