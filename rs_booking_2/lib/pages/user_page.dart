import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.token,
  }) : super(key: key);
  final String token;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Личный кабинет',
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
              .where('user_id', isEqualTo: widget.token)
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
                      snapshot.data!.docs[index].get('studio_title'),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    title: Text(
                      snapshot.data!.docs[index].get('tariff_title') +
                          '/' +
                          snapshot.data!.docs[index].get('sum').toString() + ' руб.',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data!.docs[index].get('datetime'),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      snapshot.data!.docs[index].get('login'),
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
                    'У Вас не было аренд.',
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
