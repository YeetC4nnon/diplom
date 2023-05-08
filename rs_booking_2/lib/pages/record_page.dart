// ignore_for_file: non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rs_booking_2/services/models.dart';

@RoutePage<void>()
class RecordPage extends StatefulWidget {
  const RecordPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  final int token;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  //late final ValueNotifier<Tariffs?> _tariffs;
  late Tariffs thisTariff;
  late Studio thisStudio;
  late User thisUser;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 30);

  _selectDate() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (date == null) return;

    setState(
      () {
        selectedDate = date;
      },
    );
  }

  _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time == null) return;
    setState(
      () {
        selectedTime = time;
      },
    );
  }

  /*void initState() {
    initState();
    _tariffs = ValueNotifier<Tariffs?>(null);
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreamBuilder(
              stream: getStudios(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  thisStudio = Studio(
                    address: snapshot.data!.docs[widget.token].get('address'),
                    min_cost: snapshot.data!.docs[widget.token].get('min_cost'),
                    title: snapshot.data!.docs[widget.token].get('title'),
                    studio_id:
                        snapshot.data!.docs[widget.token].get('studio_id'),
                    factor: snapshot.data!.docs[widget.token].get('factor'),
                  );
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
                        snapshot.data!.docs[widget.token]
                            .get('description')
                            .toString(),
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
              stream: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('I have a bad feeling about this');
                } else if (snapshot.hasData) {
                  thisUser = User(
                    email: snapshot.data!.docs[0].get('email'),
                    password: snapshot.data!.docs[0].get('password'),
                    name: snapshot.data!.docs[0].get('name'),
                    id: snapshot.data!.docs[0].get('id'),
                  );
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
                        snapshot.data!.docs[0].get('name'),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data!.docs[0].get('email'),
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
              stream: getTariffs(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: theme.dividerTheme.color,
                    ),
                    itemBuilder: (context, index) => Card(
                      color: theme.cardTheme.color,
                      elevation: theme.cardTheme.elevation,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _enabled = !_enabled;
                          });
                        },
                        child: ListTile(
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
                            "${snapshot.data!.docs[index].get('tariff_cost')} руб.",
                            style: theme.textTheme.titleSmall,
                          ),
                          trailing: Text(
                            snapshot.data!.docs[index].get('tariff_type'),
                            style: theme.textTheme.titleMedium,
                          ),
                          onTap: () {
                            thisTariff = Tariffs(
                              tariff_title: snapshot.data!.docs[index]
                                  .get('tariff_title'),
                              tariff_cost:
                                  snapshot.data!.docs[index].get('tariff_cost'),
                              tariff_type:
                                  snapshot.data!.docs[index].get('tariff_type'),
                            );
                          },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Выберите время: ',
                  style: theme.textTheme.titleMedium,
                ),
                InkWell(
                  onTap: _selectDate,
                  child: Row(
                    children: <Widget>[
                      Text(
                        DateFormat.yMMMd().format(selectedDate),
                        style: theme.textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                InkWell(
                  onTap: _selectTime,
                  child: Row(
                    children: <Widget>[
                      Text(
                        selectedTime.format(context),
                        style: theme.textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: (() {
                final record = Record(
                  studio_id: thisStudio.studio_id,
                  studio_title: thisStudio.title,
                  sum: thisStudio.factor * thisTariff.tariff_cost.toDouble(),
                  tariff_title: thisTariff.tariff_title,
                  tariff_type: thisTariff.tariff_type,
                  user_email: thisUser.email.toString(),
                  user_id: thisUser.id,
                  user_name: thisUser.name.toString(),
                  datetime: '${selectedDate.year}${selectedDate.month}${selectedDate.day}${selectedTime}am',
                );

                createRecord(record);
              }),
              child: const Text('Арендовать'),
            )
          ],
        ),
      ),
    );
  }
}

Future createRecord(Record record) async {
  final docRecord = FirebaseFirestore.instance.collection('records').doc();
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

Stream getStudios() =>
    FirebaseFirestore.instance.collection('studios').snapshots();

Stream getTariffs() =>
    FirebaseFirestore.instance.collection('tariffs').snapshots();

Stream getUsers() => FirebaseFirestore.instance.collection('users').snapshots();

/*getTariffs() async {
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
}*/

/*Future getDocID() {
  return FirebaseFirestore.instance
      .collection('studios')
      .doc(isUser)
      .get()
      .then(
    (DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String documentId = documentSnapshot.id;
      } else {
        print('Document does not exist');
      }
    },
  );
}*/

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
