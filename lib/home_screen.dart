import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/sign_in.dart';
import 'card edit.dart';
import 'card_creation.dart';
import 'card_item.dart';
  // Import your login screen for navigation

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final businessCardsRef = FirebaseFirestore.instance
        .collection('business_cards')
        .where('userId', isEqualTo: user?.uid);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Business Cards",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Add logout button in the AppBar
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate to login screen after signing out
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: businessCardsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No business cards found.'));
          }

          // Fetch the documents from the snapshot
          final businessCards = snapshot.data!.docs;

          return ListView.builder(
            itemCount: businessCards.length,
            itemBuilder: (context, index) {
              final cardData =
              businessCards[index].data() as Map<String, dynamic>;
              final cardId = businessCards[index].id;
              final name = cardData['name'] ?? 'No name';
              final jobTitle = cardData['job_title'] ?? 'No job title';
              final companyName = cardData['company_name'] ?? 'No company';
              final contactInfo = cardData['contact_info'] ?? 'No contact info';
              return Dismissible(
                key: Key(cardId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection('business_cards')
                      .doc(cardId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the card edit screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardEditScreen(cardId: cardId),
                      ),
                    );
                  },
                  child: CardItem(
                    name: name,
                    jobTitle: jobTitle,
                    companyName: companyName,
                    contactInfo: contactInfo,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CardCreationScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
