// ignore_for_file: non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rs_booking_2/services/models.dart';
import 'package:rs_booking_2/services/snack_bar.dart';

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
  late Tariffs thisTariff;
  late Studio thisStudio;
  late thisUser thisIsUser;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 30);
  String dropDownValue = '';

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

  bool _enabled = false;

  int _selectedIndex = -1;

  bool isCompared = false;

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
        actions: [
          Container(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: const Text(
                'Выйти',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/rs-booking.appspot.com/o/background.jpg?alt=media&token=883b2adb-c7c3-4ef1-840c-5c2cf29e515d',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                StreamBuilder(
                  stream: getStudios(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      thisStudio = Studio(
                          address:
                              snapshot.data!.docs[widget.token].get('address'),
                          min_cost:
                              snapshot.data!.docs[widget.token].get('min_cost'),
                          title: snapshot.data!.docs[widget.token].get('title'),
                          studio_id: snapshot.data!.docs[widget.token]
                              .get('studio_id'),
                          factor:
                              snapshot.data!.docs[widget.token].get('factor'),
                          login:
                              snapshot.data!.docs[widget.token].get('login'));
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data!.docs[widget.token]
                                        .get('image'),
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shadowColor: Colors.black,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            color: theme.cardTheme.color,
                            elevation: theme.cardTheme.elevation,
                            child: ListTile(
                              textColor: Colors.white,
                              contentPadding: const EdgeInsets.all(2),
                              minVerticalPadding: 2,
                              /*child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[widget.token]
                                            .get('image'),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),*/
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
                          ),
                        ],
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
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        if (isUser == snapshot.data!.docs[i].get('id')) {
                          thisIsUser = thisUser(
                            email: snapshot.data!.docs[i].get('email'),
                            password: snapshot.data!.docs[i].get('password'),
                            name: snapshot.data!.docs[i].get('name'),
                            id: snapshot.data!.docs[i].get('id'),
                          );
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 3,
                            color: const Color.fromRGBO(60, 65, 85, 1),
                            child: ListTile(
                              textColor: Colors.white,
                              leading: const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                              title: Text(
                                snapshot.data!.docs[i].get('name'),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                snapshot.data!.docs[i].get('email'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
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
                            const SizedBox(
                          height: 12,
                        ),
                        itemBuilder: (context, index) => Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                                  tariff_cost: snapshot.data!.docs[index]
                                      .get('tariff_cost'),
                                  tariff_type: snapshot.data!.docs[index]
                                      .get('tariff_type'),
                                );
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              selected: index == _selectedIndex,
                              selectedTileColor:
                                  const Color.fromARGB(255, 8, 22, 83),
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
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    DropdownButton(
                      hint: dropDownValue == null
                          ? const Text('Выберите время')
                          : Text(
                              dropDownValue,
                              style: const TextStyle(color: Colors.white),
                            ),
                      isExpanded: false,
                      iconSize: 30.0,
                      style: const TextStyle(color: Colors.white),
                      items: [
                        '09:00-10:00',
                        '10:00-11:00',
                        '11:00-12:00',
                        '12:00-13:00',
                        '13:00-14:00',
                        '14:00-15:00',
                        '15:00-16:00',
                        '16:00-17:00',
                        '17:00-18:00',
                        '19:00-20:00',
                        '20:00-21:00',
                        '21:00-22:00',
                      ].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            dropDownValue = val!;
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                StreamBuilder(
                    stream: getRecords(),
                    builder: (context, snapshot) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: (() {
                            final record = Record(
                              studio_id: thisStudio.studio_id,
                              studio_title: thisStudio.title,
                              sum: thisStudio.factor *
                                  thisTariff.tariff_cost.toDouble(),
                              tariff_title: thisTariff.tariff_title,
                              tariff_type: thisTariff.tariff_type,
                              user_email: thisIsUser.email.toString(),
                              user_id: thisIsUser.id,
                              user_name: thisIsUser.name.toString(),
                              datetime:
                                  '${selectedDate.year}${selectedDate.month}${selectedDate.day}$dropDownValue',
                              login: thisStudio.login,
                            );
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              if ('${selectedDate.year}${selectedDate.month}${selectedDate.day}$dropDownValue' !=
                                  snapshot.data.docs[i].get('datetime')) {
                                isCompared = true;
                              }
                              if ('${selectedDate.year}${selectedDate.month}${selectedDate.day}$dropDownValue' ==
                                  snapshot.data.docs[i].get('datetime')) {
                                isCompared = false;
                                break;
                              }
                            }
                            if (isCompared == true) {
                              SnackBarService.showSnackBar(
                                context,
                                'Успешно арендовано!',
                                false,
                              );
                              createRecord(record);
                            }
                            if (isCompared == false) {
                              SnackBarService.showSnackBar(
                                context,
                                'Не удалось арендовать - в это время уже занято!',
                                true,
                              );
                            }
                            /*if (selectedDate < DateTime.now()) {

                            }*/
                          }),
                          child: const Text('Арендовать'),
                        ),
                      );
                    })
              ],
            ),
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

Stream getRecords() =>
    FirebaseFirestore.instance.collection('records').snapshots();
