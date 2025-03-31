import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final String _clientId = 'YOUR_CLIENT_ID';
  final String _redirectUri = 'YOUR_REDIRECT_URI';
  final String _issuer = 'https://YOUR_DOMAIN';

  Future<Map<String, dynamic>?> login() async {
    try {
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          issuer: _issuer,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      // Check if we received a valid authorization response
      if (result != null && result.accessToken != null) {
        // Log successful authentication
        print('Authentication successful: Token received');
        
        // Parse the ID token to extract user information
        final idToken = parseIdToken(result.idToken);
        
        // Fetch additional user details using the access token
        final profile = await getUserDetails(result.accessToken);
        
        // Store tokens for later use (consider using secure storage)
        await _saveTokens(
          accessToken: result.accessToken!,
          refreshToken: result.refreshToken,
          expiresIn: result.accessTokenExpirationDateTime,
        );
        
        // Return combined user information
        return {
          'isAuthenticated': true,
          'tokenType': result.tokenType,
          'expiresAt': result.accessTokenExpirationDateTime?.toIso8601String(),
          ...idToken,
          ...profile,
        };
      } else {
        print('Authentication failed: No valid token received');
        return {'isAuthenticated': false, 'error': 'No valid token received'};
      }
    } catch (e) {
      print('Error: $e');
      return {'isAuthenticated': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic> parseIdToken(String? idToken) {
    final parts = idToken!.split('.');
    assert(parts.length == 3);

    final payload = _decodeBase64(parts[1]);
    final Map<String, dynamic> payloadMap = json.decode(payload);

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

  // Store authentication tokens securely
  Future<void> _saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresIn,
  }) async {
    // TODO: Replace with secure storage implementation
    // Consider using flutter_secure_storage package
    //print('Tokens saved: Access token valid until ${expiresIn?.toIso8601String() ?? 'unknown'}');
    
    // Example implementation with secure storage:
    final storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await storage.write(key: 'refresh_token', value: refreshToken);
    }
    if (expiresIn != null) {
      await storage.write(key: 'expires_at', value: expiresIn.toIso8601String());
    }
  }
}

