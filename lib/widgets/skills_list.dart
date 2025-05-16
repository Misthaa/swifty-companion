import 'package:flutter/material.dart';

class SkillsListWidget extends StatelessWidget {
  final Map<String, dynamic> userData;



  SkillsListWidget({required this.userData});

  Widget build(BuildContext context) {
    int cursusIndex = userData['cursus_users'].length - 1;
    return SizedBox(
      height: 300,
      child: ListView.builder(
      itemCount: userData['cursus_users'][cursusIndex]['skills']?.length ?? 0,
      itemBuilder: (context, index) {
        final skill = userData['cursus_users'][cursusIndex]['skills'][index];
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
    );
  }
}