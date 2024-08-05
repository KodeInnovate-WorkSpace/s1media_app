import 'package:flutter/material.dart';

Widget buildChooseUsContainer(String title, String subString) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffBA1D17), width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontFamily: "cgblack", fontSize: 18, color: Colors.black),
          ),
          Text(
            subString,
            style: const TextStyle(fontFamily: "cgb", fontSize: 15, color: Color(0xff8A8B8B)),
          ),
        ],
      ),
    ),
  );
}
