import 'package:flutter/material.dart';

Widget enquireTextField(TextEditingController textController, String placeholder, StateSetter setState) {
  return TextFormField(
    controller: textController,
    cursorColor: const Color(0xffdc3545),
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(color: Colors.grey, fontFamily: 'cgm'),
    decoration: InputDecoration(
      filled: true,
      hintText: placeholder,
      suffixIcon: textController.text.isNotEmpty
          ? GestureDetector(
              onTap: () {
                setState(() {
                  textController.clear();
                });
              },
              child: const Icon(
                Icons.clear_rounded,
                color: Colors.grey,
                size: 12,
              ),
            )
          : null,
      fillColor: const Color(0xfff7f8fa),
      hintStyle: const TextStyle(color: Color(0xffdcdcdc), fontFamily: 'cgm'),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: Color(0xffE8E9EB),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: Color(0xffE8E9EB),
          width: 1.0,
        ),
      ),
    ),
    autofocus: false,
    validator: (value) {
      return null;
    },
    onChanged: (value) {
      setState(() {}); // Trigger state change on text change to update suffixIcon
    },
  );
}
