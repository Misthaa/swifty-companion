import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

// import 'pages/search.dart';

void main() => runApp(MyApp());

// Page principale
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 640),
            child: child,
          ),
        );
      },
      );
  }
}

// Fonction pour récupérer le token d'accès

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

//

class SearchPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
      title: Row(
        children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SvgPicture.asset(
          'lib/assets/ft_stalk.svg',
          height: 48,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('ft_stalk', style: TextStyle(fontSize: 18)),
          Text('L\'intra, mais en mieux ?', style: TextStyle(fontSize: 12)),
          ],
        ),
        ],
      ),
      ),
      body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de recherche
          TextField(
          controller: searchController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          ),
          SizedBox(height: 16),
          // Bouton
          ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
              },
            );

            // Fetch access token
            final clientId = 'u-s4t2ud-ef5b75b28071e38346704109fb8c524a5d488beeb1625c9756244e92b6af27be';
            final clientSecret = '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';
            final token = await fetchAccessToken(clientId, clientSecret);

            await Future.delayed(Duration(seconds: 2));
            Navigator.of(context).pop();

            if (token != null) {
              // Fetch user data
              final userData = await fetchUserData(token, searchController.text);

              if (userData != null) {
              // Navigation vers la deuxième page avec les informations utilisateur
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => ResultPage(userData: userData),
                ),
              );
              } else {
              print('Aucun utilisateur trouvé');
              }
            } else {
              print('Erreur lors de la récupération du token');
            }
            
          },
          child: Icon(Icons.search),
          ),
        ],
        ),
      ),
      ),
    );
  }
}

Color _getColorForMark(dynamic mark) {
  if (mark == 0) return Colors.red;
  if (mark == null) return Colors.grey;
  if (mark > 100) return Colors.deepPurpleAccent; 
  return Colors.green;
}

// Deuxième page
class ResultPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  ResultPage({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${userData['login'] ?? 'Utilisateur'}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(150.0),
                  child: Image.network(
                  userData['image']['link'] ?? '',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                    '${userData['displayname'] ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Text(
                    '${userData['email'] ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['cursus_users'][1]['cursus']['name'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['cursus_users'][1]['level'] ?? 'N/A'} %',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['location'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.wallet,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['wallet'] ?? 'N/A'} ₳',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['phone'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    Text(
                      '${userData['correction_point'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Projets réalisés',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                  itemCount: userData['projects_users']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final project = userData['projects_users'][index];
                    return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(
                        project['project']['name'] ?? 'N/A',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                      project['final_mark'] != null
                          ? '${project['final_mark']}'
                          : 'WIP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _getColorForMark(project['final_mark']),
                      ),
                    ),
                      ],
                    ),
                    );
                  },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Compétences',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: userData['cursus_users'][1]['skills']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final skill = userData['cursus_users'][1]['skills'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              skill['name'] ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              skill['level'] != null
                                  ? '${skill['level'].toStringAsFixed(2)} %'
                                  : 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}