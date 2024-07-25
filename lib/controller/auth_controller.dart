import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    String username = "kodeinnovateworkspace@gmail.com";
    String password = "muufdqiuhdmrdzhx";

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'S1Media')
      ..recipients.add(receiverEmail)
      ..subject = 'Verification Code: $code'
      ..html = '''
    <div
      style="
      max-width: 680px;
      margin: 0 auto;
      padding: 45px 30px 60px;
      background: #f4f7ff;
      background-image: url('https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661497957196_595865/email-template-background-banner');
      background-repeat: no-repeat;
      background-size: 800px 452px;
      background-position: top center;
      font-size: 14px;
      color: #434343;
      "
    >
      <main>
        <div
          style="
          margin: 0;
          margin-top: 70px;
          padding: 92px 30px 115px;
          background: #ffffff;
          border-radius: 30px;
          text-align: center;
          "
        >
          <div style="width: 100%; max-width: 489px; margin: 0 auto;">
            <h1 style="margin: 0; font-size: 24px; font-weight: 500; color: #1f1f1f;">Your OTP</h1>
            <p style="margin: 0; margin-top: 60px; font-size: 40px; font-weight: 600; letter-spacing: 25px; color: #ba3d4f;">$code</p>
          </div>
        </div>

        <p
          style="
          max-width: 400px;
          margin: 0 auto;
          margin-top: 90px;
          text-align: center;
          font-weight: 500;
          color: #8c8c8c;
          "
        >
          Need help? Ask at
          <a href="mailto:info@kodeinnovate.in" style="color: #499fb6; text-decoration: none;">info@kodeinnovate.in</a>
          
        </p>
      </main>
    </div>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
      Get.to(() => OTPScreen(
            email: receiverEmail,
            otp: code,
          ));
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

  Future<void> saveUser(String userEmail) async {
    // Get today's date
    String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var userId = const Uuid().v4();
    Map<String, dynamic> userFields = {
      'id': userId,
      'email': userEmail,
      'date': todayDate,
    };

    try {
      await checkUserExistence(userEmail);
      if (!_isUserExist) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set(userFields);
        Get.to(() => PhoneScreen(email: userEmail));
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
