import 'package:flutter/material.dart';

Color _getColorForMark(dynamic mark) {
  if (mark == 0) return Colors.red;
  if (mark == null) return Colors.grey;
  if (mark > 100) return Colors.deepPurpleAccent; 
  return Colors.green;
}

class ProjectListWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  ProjectListWidget({required this.userData});

  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: userData['projects_users'].length,
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
    );
  }
}