import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';

class UserController {
  Stream<Map<String, String?>> getUserDetailsStream() async* {
    final authController = AuthController();
    await authController.retrieveUser();

    final userStream = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: authController.email).snapshots();

    yield* userStream.map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        final userFetchedEmail = userData['email'];
        final userFetchedPhone = userData['phone'];
        return {'email': userFetchedEmail, 'phone': userFetchedPhone};
      } else {
        return {'email': null, 'phone': null};
      }
    });
  }
}
