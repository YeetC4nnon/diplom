import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking_2/pages/record_page.dart';

@RoutePage<void>()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Главная страница',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder(
        stream: getStudios(),
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
              itemBuilder: (context, index) => SizedBox(
                height: 150,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: theme.cardTheme.color,
                  elevation: theme.cardTheme.elevation,
                  child: SizedBox(
                    height: 150,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(2),
                      minVerticalPadding: 2,
                      leading: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data!.docs[index].get('image'),
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data!.docs[index].get('title'),
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        "От: ${snapshot.data!.docs[index].get('min_cost')} руб.",
                        style: theme.textTheme.titleSmall,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordPage(token: index),
                          ),
                        );
                        //print(index);
                      },
                    ),
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
    );
  }
}

Stream getStudios() =>
    FirebaseFirestore.instance.collection('studios').snapshots();
