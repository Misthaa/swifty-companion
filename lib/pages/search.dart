import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/api_fetch.dart';
import 'result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

                  final clientId = dotenv.env['UID_42'];
                  final clientSecret = dotenv.env['SECRET_42'];
                  final token = await fetchAccessToken(clientId!, clientSecret!);

                  await Future.delayed(Duration(seconds: 2));
                  Navigator.of(context).pop();

                  if (token != null) {
                    final userData = await fetchUserData(token, searchController.text);

                    if (userData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(userData: userData),
                        ),
                      );
                    } else {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                          title: Text('Utilisateur introuvable'),
                            content: Text(
                            'Aucun utilisateur correspondant n\'a été trouvé.',
                            style: TextStyle(color: Colors.black),
                            ),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                            ),
                          ],
                          );
                        },
                        );
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