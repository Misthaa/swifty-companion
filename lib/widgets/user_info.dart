import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserInfoWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  UserInfoWidget({required this.userData});

  @override
  Widget build(BuildContext context) {
    int cursusIndex = userData['cursus_users'].length - 1;

    return Container(
      padding: const EdgeInsets.all(16.0),
      
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              userData['image']['link'] ?? 'https://example.com/default_avatar.png',
            ),
            radius: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Flexible(
                      child: AutoSizeText(
                        '${userData['email'] ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      '${userData['cursus_users'][cursusIndex]['cursus']['name'] ?? 'N/A'}',
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
                      '${userData['cursus_users'][cursusIndex]['level'] ?? 'N/A'} %',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    Flexible(
                      child: AutoSizeText(
                        '${userData['displayname'] ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}