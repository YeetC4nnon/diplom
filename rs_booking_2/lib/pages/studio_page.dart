import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudioPage extends StatefulWidget {
  const StudioPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  final String token;

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.token,
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('records')
              .where('login', isEqualTo: widget.token)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: theme.dividerTheme.color,
                ),
                itemBuilder: (context, index) => Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  color: const Color.fromRGBO(60, 65, 85, 1),
                  child: ListTile(
                    dense: true,
                    textColor: Colors.white,
                    leading: Text(
                      snapshot.data!.docs[index].get('user_name'),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    title: Text(
                      snapshot.data!.docs[index].get('tariff_title') +
                          '/' +
                          snapshot.data!.docs[index].get('sum').toString() + ' руб.',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.docs[index].get('datetime'),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      snapshot.data!.docs[index].get('user_email'),
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                color: const Color.fromRGBO(60, 65, 85, 1),
                child: Center(
                  child: Text(
                    'В вашу студию нет записей.',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
