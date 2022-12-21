import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';

class RecordPage extends StatefulWidget {
  RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        studio.title,
      )),
    );
  }
}

Stream<List<Studio>> studios() => FirebaseFirestore.instance
    .collection('studios')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Studio.fromJson(doc.data())).toList());
