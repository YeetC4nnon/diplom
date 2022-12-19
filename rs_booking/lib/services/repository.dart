import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rs_booking/services/models.dart';

class MockRepository {
  Stream<List<Studio>> studios() => FirebaseFirestore.instance
      .collection('studios')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Studio.fromJson(doc.data())).toList());
}
