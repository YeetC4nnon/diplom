import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking_2/services/models.dart';

@RoutePage<void>()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _documentsCount = 0;

  @override
  void initState() {
    super.initState();
    getDocumentsCount().then((count) {
      setState(() {
        _documentsCount = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главная страница',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getStudios(),
        builder: (context, snapshot) {
          Map<String, dynamic> data;
          data = snapshot.data?.data() as Map<String, dynamic>;
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return ListView.separated(
              itemCount: _documentsCount,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: theme.dividerTheme.color,
              ),
              itemBuilder: (context, index) => Card(
                color: theme.cardTheme.color,
                elevation: theme.cardTheme.elevation,
                child: ListTile(
                  leading: const Icon(Icons.audiotrack_rounded),
                  title: Text(
                    data['title'],
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    "От: ${data['min_cost']} руб.",
                    style: theme.textTheme.titleSmall,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('RecordPage');
                  },
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

Stream<DocumentSnapshot> getStudios() =>
    FirebaseFirestore.instance.collection('studios').doc(isUser).snapshots();

Future<int> getDocumentsCount() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('studios').get();
  int count = querySnapshot.size;
  return count;
}
