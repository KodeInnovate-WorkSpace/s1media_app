import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:s1media_app/screens/phone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:uuid/uuid.dart';
import '../screens/OTP.dart';

class AuthController {
  final TextEditingController textEmailController = TextEditingController();
  bool _isUserExist = false;
  bool get isUserExist => _isUserExist;
  bool isLoading = false;

  String get email => textEmailController.text;

  Future<void> sendMail(String receiverEmail, String code) async {
    String username = dotenv.env['EMAIL']!;
    String password = dotenv.env['APP_PASSWORD']!;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'S1Media')
      ..recipients.add(receiverEmail)
      ..subject = 'Verification Code: $code'
      ..html = '''
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify your login</title>
  <!--[if mso]><style type="text/css">body, table, td, a { font-family: Arial, Helvetica, sans-serif !important; }</style><![endif]-->
</head>

<body style="font-family: Helvetica, Arial, sans-serif; margin: 0px; padding: 0px; background-color: #ffffff;">
  <table role="presentation"
    style="width: 100%; border-collapse: collapse; border: 0px; border-spacing: 0px; font-family: Arial, Helvetica, sans-serif; background-color: rgb(220, 53, 69);">
    <tbody>
      <tr>
        <td align="center" style="padding: 1rem 2rem; vertical-align: top; width: 100%;">
          <table role="presentation" style="max-width: 600px; border-collapse: collapse; border: 0px; border-spacing: 0px; text-align: left;">
            <tbody>
              <tr>
                <td style="padding: 40px 0px 0px;">
                  <div style="text-align: left;">
                    <!---->
                  </div>
                  <div style="padding: 20px; background-color: rgb(255, 255, 255);">
                    <div style="color: rgb(0, 0, 0); text-align: center;">
                      <h1 style="margin: 1rem 0">Verification code</h1>
                      <p style="padding-bottom: 16px">Please use the verification code below to login.</p>
                      <p style="padding-bottom: 16px"><strong style="font-size: 130%">$code</strong></p>
                      <p style="padding-bottom: 16px">If you didn’t request this, you can ignore this email.</p>
                      <p style="padding-bottom: 16px">Thanks,<br>S1Media</p>
                    </div>
                  </div>
                  <div style="padding-top: 20px; color: rgb(153, 153, 153); text-align: center;"></div>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table>
</body>

</html>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      Get.to(
          () => OtpScreen(
                email: receiverEmail,
                otp: code,
              ),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Message not sent: $e');
    }
  }

  // Check if User Exists
  Future<void> checkUserExistence(String userEmail) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('users').where('email', isEqualTo: userEmail).get();
      _isUserExist = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint("Error checking user existence: $e");
      _isUserExist = false;
    }
  }

  Future<int?> userType(String userEmail) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      Query query = firestore.collection('users').where('email', isEqualTo: userEmail);

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;

        return doc.get('type');
      } else {
        debugPrint("No user found with email: $userEmail");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user type: $e");
      return null;
    }
  }

  Future<void> saveUser(String userEmail) async {
    // Get today's date
    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var userId = const Uuid().v4();
    Map<String, dynamic> userFields = {
      'id': userId,
      'email': userEmail,
      'date': todayDate,
      'type': 0,
    };

    try {
      await checkUserExistence(userEmail);
      if (!_isUserExist) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set(userFields);
        Get.to(() => PhoneScreen(email: userEmail), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));
      } else {
        debugPrint("User already exists.");
        await sendMail(userEmail, generateOtp());
      }
    } catch (e) {
      debugPrint("Error storing user in firebase: $e");
    }
  }

  Future<void> updateField(String userEmail, String field, String value) async {
    try {
      Query query = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail);
      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({field: value});
      }
    } catch (e) {
      debugPrint("Error updating users: $e");
    }
  }

  String generateOtp() {
    var rng = Random();
    debugPrint("OTP: ${rng.toString()}");
    return (rng.nextInt(900000) + 100000).toString();
  }

  Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);

    if (textEmailController.text.isEmpty) {
      textEmailController.text = prefs.getString('userEmail') ?? '';
    }
  }

  Future<void> retrieveUser() async {
    final prefs = await SharedPreferences.getInstance();
    textEmailController.text = prefs.getString('userEmail') ?? '';
  }

  void reset() {
    textEmailController.clear();
    isLoading = false;
  }
}
