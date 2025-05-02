import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SWESearch_view.dart';
import '../globals/user_info.dart';
import '../model/SWE_List_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late CollectionReference favoritesRef;

  @override
  void initState() {
    super.initState();
    favoritesRef = FirebaseFirestore.instance
        .collection('Login-Info')
        .doc(currentUserEmail)
        .collection('favorites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(data['Title'] ?? 'No Title'),
                  subtitle: Text('${data['company'] ?? 'Unknown'} • ${data['location'] ?? 'Unknown'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Remove from favorites
                      favoritesRef.doc(docs[index].id).delete();
                    },
                  ),
                  onTap: () {
                    // Optional: Navigate to job details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

