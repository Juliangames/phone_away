import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class InviteHelper {
  static const String _apiKey = 'AIzaSyCjpDe5qbe-APdpaiM6MqdNJH7kXirr758';
  static const String _domainUriPrefix = 'https://phoneaway.page.link';
  static const String _androidPackageName = 'com.example.phone_away';
  static const String _iosBundleId = ' com.example.phoneAway ';

  static Future<String?> createDynamicInviteLink(String userId) async {
    final Uri uri = Uri.parse(
      'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$_apiKey',
    );

    final Map<String, dynamic> body = {
      "dynamicLinkInfo": {
        "domainUriPrefix": _domainUriPrefix,
        "link": "$_domainUriPrefix/friends?from=$userId",
        "androidInfo": {"androidPackageName": _androidPackageName},
        "iosInfo": {"iosBundleId": _iosBundleId},
      },
      "suffix": {"option": "SHORT"},
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['shortLink'];
    } else {
      debugPrint("Fehler beim Erstellen des Links: ${response.body}");
      return null;
    }
  }
}
