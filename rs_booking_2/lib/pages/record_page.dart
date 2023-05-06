// ignore_for_file: non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking_2/services/models.dart';
import 'package:rs_booking_2/widgets/widgets.dart';

@RoutePage<void>()
class RecordPage extends StatefulWidget {
  RecordPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  final int token;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late final ValueNotifier<Tariffs?> _tariffs;

  final _studioIDController = TextEditingController();

  final _studioTitleController = TextEditingController();

  final _studioSumController = TextEditingController();

  final _userEmailController = TextEditingController();

  final _userIDController = TextEditingController();

  final _userNameController = TextEditingController();

  /*void initState() {
    initState();
    _tariffs = ValueNotifier<Tariffs?>(null);
  }*/

  /*void dispose() {
    _tariffs.dispose();
    _studioIDController.dispose();
    _studioTitleController.dispose();
    _studioSumController.dispose();
    _userEmailController.dispose();
    _userIDController.dispose();
    _userNameController.dispose();
    dispose();
  }*/

  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Аренда',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('studios').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                return Card(
                  color: theme.cardTheme.color,
                  elevation: theme.cardTheme.elevation,
                  child: ListTile(
                    textColor: Colors.white,
                    leading: const Icon(
                      Icons.audiotrack_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      snapshot.data!.docs[widget.token].get('title'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.docs[widget.token].get('description'),
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
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('studios').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              Tariffs tariffs =
                  Tariffs.fromDocument(snapshot.data!.docs[widget.token]);
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('studios')
                      .doc(isUser)
                      .collection('tariffs')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 14,
                      ),
                      itemBuilder: (context, index) => Card(
                        elevation: theme.cardTheme.elevation,
                        color: const Color.fromARGB(255, 66, 62, 49),
                        child: InkWell(
                          onTap: () {
                            setState(() => _enabled = !_enabled);
                          },
                          child: ListTile(
                            textColor: Colors.white,
                            leading: Icon(
                              _enabled
                                  ? Icons.radio_button_off
                                  : Icons.radio_button_checked,
                              color: Colors.white,
                            ),
                            title: Text(
                              snapshot.data!.docs[index].get('tariff_title'),
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              '${snapshot.data!.docs[index].get('tariff_cost')}руб.',
                              style: theme.textTheme.titleSmall,
                            ),
                            trailing: Text(
                              snapshot.data!.docs[index].get('tariff_type'),
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
          ElevatedButton(
            onPressed: (() {
              final record = Record(
                studio_id: int.parse(_studioIDController.text),
                sum: double.parse(_studioSumController.text),
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

getTariffs() async {
  await FirebaseFirestore.instance.collection('studios').get().then(
    (querySnapshot) async {
      querySnapshot.docs.forEach(
        (result) async {
          await FirebaseFirestore.instance
              .collection('studios')
              .doc(result.id)
              .collection('tariffs')
              .get()
              .then(
            (querySnapshot) {
              querySnapshot.docs.forEach(
                (result) {
                  Tariffs tariffs = Tariffs.fromDocument(result);
                },
              );
            },
          );
        },
      );
    },
  );
}

Future createRecord(Record record) async {
  final docRecord =
      FirebaseFirestore.instance.collection('records').doc(isUser);

  final json = record.toJson();

  await docRecord.set(json);
}

class Tariffs {
  final String tariff_title;
  final double tariff_cost;
  final String tariff_type;

  Tariffs({
    required this.tariff_title,
    required this.tariff_cost,
    required this.tariff_type,
  });

  factory Tariffs.fromDocument(DocumentSnapshot documentSnapshot) {
    return Tariffs(
      tariff_title: documentSnapshot['tariff_title'],
      tariff_cost: documentSnapshot['tariff_cost'],
      tariff_type: documentSnapshot['tariff_type'],
    );
  }
}

/*class _RadioButton extends StatelessWidget {
  final String title;
  final int tariff_cost;
  final ValueNotifier<Tariffs?> tariffs;
  final int index;
  final String type;
  const _RadioButton({
    required this.index,
    required this.tariffs,
    required this.title,
    required this.tariff_cost,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: tariffs,
        builder: (context, _) => Radio(
            value: tariffs.value = Tariffs.values[index],
            groupValue: null,
            onChanged: (_) => tariffs.value = Tariffs.values[index]),
      );
}*/

//enum Tariffs { a, b, c }
