import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';

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
        .doc(globalEmail)
        .collection('favorites');
  }

  TextStyle _descriptionStyle() => const TextStyle(
    color: Color.fromARGB(255, 34, 124, 157),
    fontFamily: 'JetB',
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 226),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Favorite Jobs',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 0, 43, 75),
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 43, 75)),
      ),
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
                color: const Color.fromARGB(255, 230, 230, 226),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                  backgroundColor: const Color.fromARGB(255, 230, 230, 226),
                  title: Text(
                    data['Title'] ?? 'No Title',
                    style: const TextStyle(
                      fontFamily: 'inter',
                      color: Color.fromARGB(255, 0, 43, 75),
                    ),
                  ),
                  subtitle: Text(
                    '${data['Company'] ?? 'Unknown'} • ${data['Location'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontFamily: 'JetB',
                      color: Color.fromARGB(255, 17, 84, 116),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoritesRef.doc(docs[index].id).delete();
                    },
                  ),
                  children: [
                    const Divider(
                      color: Color.fromARGB(255, 0, 43, 75),
                      thickness: 2,
                    ),
                    ListTile(
                      title: Text(
                        'Company Score: ${data['Company Score'] ?? 'N/A'}',
                        style: _descriptionStyle(),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Date Posted: ${data['Date'] ?? 'N/A'}',
                            style: _descriptionStyle(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Salary: ${data['Salary'] ?? 'N/A'}',
                            style: _descriptionStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
