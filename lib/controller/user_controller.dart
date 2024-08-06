import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'auth_controller.dart';

class UserController {
  Logger logger = Logger();
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
        logger.w("Email not found, Phone not found");

        return {'email': null, 'phone': null};
      }
    });
  }

  Future<String> retrieveWhatsappNumber() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("whatsappNumber").get();
      if (snapshot.docs.isNotEmpty) {
        String phoneNumber = snapshot.docs.first['phone'].toString();
        return phoneNumber;
      } else {
        throw Exception("No documents found in the collection");
      }
    } catch (e) {
      logger.e("Error getting whatsapp number", error: e);
      rethrow;
    }
  }
}
