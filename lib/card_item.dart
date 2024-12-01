import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String companyName;
  final String contactInfo;

  const CardItem({
    Key? key,
    required this.name,
    required this.jobTitle,
    required this.companyName,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobTitle, style: const TextStyle(fontSize: 14)),
            Text(companyName, style: const TextStyle(fontSize: 14)),
            Text(contactInfo, style: const TextStyle(fontSize: 14)),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
