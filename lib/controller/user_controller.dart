import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s1media_app/controller/auth_controller.dart';

class UserController {
  String? userFetchedEmail;
  String? userFetchedPhone;

  Future<Map<String, String?>> fetchUserDetails() async {
    AuthController authController = AuthController();
    await authController.retrieveUser();

    try {
      var userSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: authController.email).get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data();
        userFetchedEmail = userData['email'];
        log("User Email: $userFetchedEmail");
        userFetchedPhone = userData['phone'];
        log("User Phone: $userFetchedPhone");

        return {
          'email': userFetchedEmail,
          'phone': userFetchedPhone
        };
      }
    } catch (e) {
      log("Error getting user details: $e");
    }
    return {
      'email': null,
      'phone': null
    };
  }
}

