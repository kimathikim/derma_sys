import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final String _clientId = 'YOUR_CLIENT_ID';
  final String _redirectUri = 'YOUR_REDIRECT_URI';
  final String _issuer = 'https://YOUR_DOMAIN';

  Future<Map<String, dynamic>?> login() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          issuer: _issuer,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (result != null) {
        final idToken = parseIdToken(result.idToken);
        final profile = await getUserDetails(result.accessToken);
        return {...idToken, ...profile};
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Map<String, dynamic> parseIdToken(String? idToken) {
    final parts = idToken!.split('.');
    assert(parts.length == 3);

    final payload = _decodeBase64(parts[1]);
    final Map<String, dynamic> payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid ID token');
    }

    return payloadMap;
  }

  Future<Map<String, dynamic>> getUserDetails(String? accessToken) async {
    final url = '$_issuer/userinfo';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }
}

