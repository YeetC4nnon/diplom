import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';
import 'package:rs_booking/widgets/list_status_indicator.dart';
import 'services/list_controller.dart';
import 'package:provider/provider.dart';
import 'package:rs_booking/services/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //final listController = context.watch<ListController>();
    //final listState = listController.value;
    //final itemCount = listState.studios.length +
    //    (ListStatusIndicator.hasStatus(listState) ? 1 : 0);
    return Scaffold(
      appBar: AppBar(title: const Text("Главная")),
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: StreamBuilder<List<Studio>>(
        stream: studios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('I haave a bad feeling about this');
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

Widget buildStudio(Studio studio) => ListTile(
      title: Text(studio.title),
    );
/*ListView.builder(
        itemBuilder: (context, index) {
          if (index == listState.studios.length &&
              ListStatusIndicator.hasStatus(listState)) {
            return ListStatusIndicator(listState,
                onRepeat: listController.repeatQuery);
          }

          final record = listState.studios[index];
          return ListTile(
            title: Text(record.title),
            tileColor: const Color.fromRGBO(50, 65, 85, 0.8),
            textColor: Colors.white,
          );
        },
        itemCount: itemCount,
      ),*/