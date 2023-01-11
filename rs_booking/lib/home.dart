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
      appBar: AppBar(
          title: const Text(
        "Главная",
        style: TextStyle(color: Colors.white),
      )),
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: studios(),
        builder: (context, snapshot) {
          Map<String, dynamic>? data;
          data = snapshot.data?.data() as Map<String, dynamic>?;
          if (snapshot.hasError) {
            return const Text('I have a bad feeling about this');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                //studios.map(buildStudio).toList();
                return Card(
                  elevation: 1,
                  color: const Color.fromRGBO(60, 65, 85, 1),
                  child: ListTile(
                    textColor: Colors.white,
                    leading: const Icon(
                      Icons.audiotrack_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      data?['title'],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "От: ${data?['min_cost']} руб.",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    onTap: (() {
                      Navigator.of(context).pushNamed(
                        '/recordPage',
                        arguments: data,
                      );
                    }),
                  ),
                );
              },
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

Stream<DocumentSnapshot> studios() => FirebaseFirestore.instance
    .collection('studios')
    .doc('U3imVeOROUULWOICBezC')
    .snapshots();

dynamic buildStudio(Studio studio, BuildContext context) => Card(
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
          "От: ${studio.min_cost} руб.",
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        onTap: (() {
          Navigator.of(context).pushNamed(
            'recordPage',
            arguments: studio,
          );
        }),
      ),
    );

/*void sendStudioDoc() {
  FirebaseFirestore.instance.collection('studio').doc().id;
}*/
