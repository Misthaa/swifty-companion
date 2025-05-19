import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchAccessToken(String clientId, String clientSecret) async {
  final response = await http.post(
    Uri.parse('https://api.intra.42.fr/oauth/token'),
    body: {
      'grant_type': 'client_credentials',
      'client_id': clientId,
      'client_secret': clientSecret,
    },
  );


  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Access Token: ${data['access_token']}');
    return data['access_token'];
  } else {
    print('Erreur : ${response.statusCode}');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchUserData(String token, String query) async {
  final response = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/users/$query'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Erreur de récupération des données utilisateur');
    return null;
  }
}