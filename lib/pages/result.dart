import 'package:flutter/material.dart';
import 'package:swifty_companion/widgets/user_info.dart';
import '../widgets/project_list.dart';
import '../widgets/skills_list.dart';

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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            UserInfoWidget(userData: userData),
            SizedBox(height: 16),
            Text(
              'Projets',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: ProjectListWidget(userData: userData),
            ),
            SizedBox(height: 16),
            Text(
              'Compétences',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: SkillsListWidget(userData: userData),
            ),
          ],
        ),
      ),
    );
  }
} 
