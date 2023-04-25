import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';

class RecordPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const RecordPage({
    Key? key,
    @required this.data,
  }) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _studioIDController = TextEditingController();
  final _studioTitleController = TextEditingController();
  final _studioSumController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userIDController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Аренда',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: Column(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('studios')
                .doc(isUser)
                .snapshots(),
            builder: (context, snapshot) {
              Map<String, dynamic>? data;
              data = snapshot.data?.data() as Map<String, dynamic>?;
              if (snapshot.hasError) {
                return const Text('I have a bad feeling about this');
              } else if (snapshot.hasData) {
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
                      data?['description'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(isUser)
                .snapshots(),
            builder: (context, snapshot) {
              Map<String, dynamic>? data;
              data = snapshot.data?.data() as Map<String, dynamic>?;
              if (snapshot.hasError) {
                return const Text('I have a bad feeling about this');
              } else if (snapshot.hasData) {
                return Card(
                  elevation: 1,
                  color: const Color.fromRGBO(60, 65, 85, 1),
                  child: ListTile(
                    textColor: Colors.white,
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    title: Text(
                      data?['name'],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      data?['email'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: (() {
              final record = Record(
                studio_id: int.parse(_studioIDController.text),
                sum: int.parse(_studioSumController.text),
                user_id: int.parse(_userIDController.text),
                studio_title: _studioTitleController.text,
                user_email: _userEmailController.text,
                user_name: _userNameController.text,
              );

              createRecord(record);
            }),
            child: const Text('Арендовать'),
          )
        ],
      ),
    );
  }
}

Future createRecord(Record record) async {
  final docRecord = FirebaseFirestore.instance.collection('records').doc();

  final json = record.toJson();

  await docRecord.set(json);
}

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
          studio.description,
          style: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );

Stream getStudios(doc) async* {
  var collection = FirebaseFirestore.instance.collection('studios').doc(doc);
  var querySnapshot = collection.snapshots();
  yield querySnapshot;
}

Stream getUsers(doc) async* {
  var collection = FirebaseFirestore.instance.collection('users').doc(doc);
  var querySnapshot = collection.snapshots();
  yield querySnapshot;
}

Stream<List<Studio>> studios() => FirebaseFirestore.instance
    .collection('studios')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Studio.fromJson(doc.data())).toList());

Stream<List<thisUser>> users() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => thisUser.fromJson(doc.data())).toList());
