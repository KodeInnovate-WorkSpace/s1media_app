import 'package:flutter/material.dart';

class EnquireForm extends StatefulWidget {
  final Map<String, String?> userDetails;

  const EnquireForm({super.key, required this.userDetails});

  @override
  State<EnquireForm> createState() => _EnquireFormState();
}

class _EnquireFormState extends State<EnquireForm> {
  late String? email;
  late String? phone;

  @override
  void initState() {
    super.initState();
    email = widget.userDetails['email'];
    phone = widget.userDetails['phone'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextFormField(
              initialValue: email,
              cursorColor: const Color(0xffdc3545),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your email address",
                hintStyle: TextStyle(color: Color(0xffdcdcdc)),
              ),
              autofocus: false,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Phone
            TextFormField(
              initialValue: phone,
              cursorColor: const Color(0xffdc3545),
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your phone number",
                hintStyle: TextStyle(color: Color(0xffdcdcdc)),
              ),
              autofocus: false,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Name
            TextFormField(
              cursorColor: const Color(0xffdc3545),
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your name",
                hintStyle: TextStyle(color: Color(0xffdcdcdc)),
              ),
              autofocus: true,
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Service
          ],
        ),
      ),
    );
  }
}
