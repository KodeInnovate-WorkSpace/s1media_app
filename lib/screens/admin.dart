import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/add_service.dart';
import 'package:s1media_app/screens/home.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(fontFamily: 'cgb'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_backspace),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // User details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // User count with flow chart
                customContainer(context, "Users", 165, 100, "users"),
                // Total services
                customContainer(context, "Service", 165, 100, "service"),
              ],
            ),
            // Add service new
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Services",
                  style: TextStyle(fontFamily: "cgb", fontSize: 20),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Color(0xffdc3545), fontFamily: 'cgblack'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer(BuildContext context, String pageName, double wid, double hei, String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final servicesCount = snapshot.data!.docs.length;
        return Container(
          width: wid,
          height: hei,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xffdc3545), width: 2.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    servicesCount.toString(),
                    style: const TextStyle(color: Color(0xffdc3545), fontSize: 20, fontFamily: 'cgblack'),
                  ),
                  Text(
                    pageName,
                    style: const TextStyle(color: Color(0xffdc3545), fontSize: 17, fontFamily: 'cgb'),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 6,
                decoration: const BoxDecoration(
                  color: Color(0xffdc3545),
                ),
                child: Icon(
                  pageName == "Users" ? Icons.person : Icons.category,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
