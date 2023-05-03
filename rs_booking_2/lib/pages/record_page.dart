// ignore_for_file: non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking_2/services/models.dart';
import 'package:rs_booking_2/widgets/widgets.dart';

@RoutePage<void>()
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
  late final ValueNotifier<Tariffs?> _tariffs;
  final _studioIDController = TextEditingController();
  final _studioTitleController = TextEditingController();
  final _studioSumController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userIDController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tariffs = ValueNotifier<Tariffs?>(null);

    /*getDocumentsCount().then((count) {
      setState(() {
        _documentsCount = count;
      });
    });*/
  }

  @override
  void dispose() {
    _tariffs.dispose();
    _studioIDController.dispose();
    _studioTitleController.dispose();
    _studioSumController.dispose();
    _userEmailController.dispose();
    _userIDController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future<int> getDocumentsCount() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('studios').get();
    int count = querySnapshot.size;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: null,
        builder: (context, snapshot) {
          Map<String, dynamic>? data;
          data = snapshot.data?.data() as Map<String, dynamic>?;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Аренда',
                style: theme.textTheme.bodyLarge,
              ),
              backgroundColor: theme.appBarTheme.backgroundColor,
            ),
            body: Column(
              children: <Widget>[
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('studios')
                      .doc(isUser)
                      .snapshots(),
                  builder: (context, snapshot) {
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
                ColumnBuilder.separator(
                  itemBuilder: (context, index) => _RadioButton(
                    title: data?['tariff_name'],
                    index: index,
                    tariffs: _tariffs,
                    tariff_cost: data?['tariff_cost'],
                  ),
                  itemCount: 4,
                  separator: (context, index) => const SizedBox(
                    height: 12,
                  ),
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
        });
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
