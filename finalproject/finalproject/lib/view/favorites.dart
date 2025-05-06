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

  TextStyle _descriptionStyle() {
    return TextStyle(
      color: Theme.of(context).textTheme.bodyMedium!.color,
      fontFamily: 'JetB',
      fontSize: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Dark and light mode color settings
    final Color backgroundColor =
        isDarkMode
            ? const Color.fromARGB(
              255,
              80,
              80,
              80,
            ) // Custom dark background color
            : const Color.fromARGB(
              255,
              244,
              243,
              240,
            ); // Custom light background color

    final Color appBarColor =
        isDarkMode
            ? const Color.fromARGB(255, 0, 43, 75) // Custom dark appBar color
            : const Color.fromARGB(
              255,
              230,
              230,
              226,
            ); // Custom light appBar color

    final Color cardColor =
        isDarkMode
            ? const Color.fromARGB(255, 60, 60, 60) // Dark card color
            : const Color.fromARGB(255, 230, 230, 226); // Light card color

    final Color titleColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 0, 43, 75);
    final Color subtitleColor =
        isDarkMode
            ? const Color.fromARGB(255, 151, 151, 151)
            : const Color.fromARGB(255, 17, 84, 116);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 2,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Favorite Jobs',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: titleColor),
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
                color: cardColor,
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
                  backgroundColor: cardColor,
                  title: Text(
                    data['Title'] ?? 'No Title',
                    style: TextStyle(fontFamily: 'inter', color: titleColor),
                  ),
                  subtitle: Text(
                    '${data['Company'] ?? data['Category']} • ${data['Location'] ?? 'Unknown'}',
                    style: TextStyle(fontFamily: 'JetB', color: subtitleColor),
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
                        '${data['Company Score'] != null ? 'Company Score' : 'Work Setting'}: ${data['Company Score'] ?? data['Work Setting'] ?? 'N/A'}',
                        style: _descriptionStyle(),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data['Employment Type'] != null)
                            Text(
                              'Employment Type: ${data['Employment Type'] ?? "N/A"}',
                              style: _descriptionStyle(),
                            ),
                          Text(
                            '${data['Date'] != null ? 'Date Posted' : 'Work Year'} : ${data['Date'] ?? data['Year'] ?? "N/A"}',
                            style: _descriptionStyle(),
                          ),
                          if (data['Size'] != null)
                            Text(
                              'Company Size: ${data['Size'] ?? "N/A"}',
                              style: _descriptionStyle(),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Salary: ${data['Salary'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 17, 84, 116),
                              fontFamily: 'JetB',
                            ),
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
