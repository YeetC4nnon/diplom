import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Главная")),
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: StreamBuilder<List<Studio>>(
        stream: studios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('I have a bad feeling about this');
          } else if (snapshot.hasData) {
            final studios = snapshot.data!;
            return ListView(
              children: studios.map(buildStudio).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Stream<List<Studio>> studios() => FirebaseFirestore.instance
    .collection('studios')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Studio.fromJson(doc.data())).toList());

Widget buildStudio(Studio studio) => Card(
      elevation: 1,
      color: const Color.fromRGBO(60, 65, 85, 1),
      child: ListTile(
        textColor: Colors.white,
        leading: const Icon(
          Icons.audiotrack_rounded,
          color: Colors.white,
        ),
        title: Text(
          studio.title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          "Цена за 1 час: ${studio.sum} руб.",
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
