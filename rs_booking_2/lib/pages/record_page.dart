// ignore_for_file: non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking_2/services/models.dart';
import 'package:rs_booking_2/widgets/widgets.dart';

@RoutePage<void>()
class RecordPage extends StatelessWidget {
  RecordPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  final int token;
  late final ValueNotifier<Tariffs?> _tariffs;
  final _studioIDController = TextEditingController();
  final _studioTitleController = TextEditingController();
  final _studioSumController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userIDController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  void initState() {
    initState();
    _tariffs = ValueNotifier<Tariffs?>(null);
  }

  @override
  void dispose() {
    //_tariffs.dispose();
    _studioIDController.dispose();
    _studioTitleController.dispose();
    _studioSumController.dispose();
    _userEmailController.dispose();
    _userIDController.dispose();
    _userNameController.dispose();
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                      snapshot.data!.docs[token].get('title'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.docs[token].get('description'),
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
          /*StreamBuilder(
            stream: FirebaseFirestore.instance.collection('studios').snapshots(),
            builder: (context, snapshot) {
              return ColumnBuilder.separator(
                itemBuilder: (context, index) => _RadioButton(
                  title: snapshot.data!.docs[token].get('tariff_name'),
                  index: index,
                  tariffs: _tariffs,
                  tariff_cost: snapshot.data!.docs[token].get('tariff_cost'),
                ),
                itemCount: 4,
                separator: (context, index) => const SizedBox(
                  height: 12,
                ),
              );
            }
          ),*/
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

Future createRecord(Record record) async {
  final docRecord =
      FirebaseFirestore.instance.collection('records').doc(isUser);

  final json = record.toJson();

  await docRecord.set(json);
}

class _RadioButton extends StatelessWidget {
  final String title;
  final int tariff_cost;
  final ValueNotifier<Tariffs?> tariffs;
  final int index;
  const _RadioButton({
    required this.index,
    required this.tariffs,
    required this.title,
    required this.tariff_cost,
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
}

enum Tariffs { a, b, c }
