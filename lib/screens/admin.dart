import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:s1media_app/screens/update_service.dart';

import 'add_service.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
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
            const SizedBox(height: 20),
            // Add service new
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Services",
                    style: TextStyle(fontFamily: "cgb", fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => const AddService(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
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
            ),
            const SizedBox(height: 20),
            // Scrollable container with list of services
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('service').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final services = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Dismissible(
                        key: Key(service.id),
                        background: Container(color: const Color(0xffdc3545)),
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.black),
                              ),
                              content: const Text(
                                "Are you sure you want to delete this?",
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(Colors.red[900]),
                                      ),
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                          color: Color(0xffEF4B4B),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await deleteService(service['id']);
                                        Get.back();
                                      },
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(Colors.grey[700]),
                                      ),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            service['title'],
                            style: const TextStyle(
                              fontFamily: 'cgblack',
                            ),
                          ),
                          subtitle: Text(
                            service['subText'],
                            style: const TextStyle(
                              fontFamily: 'cgm',
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xffdc3545)),
                            onPressed: () {
                              Get.to(
                                () => UpdateService(
                                  serviceId: service.id,
                                  title: service['title'],
                                  subText: service['subText'],
                                  vidUrls: List<String>.from(service['vidUrls']),
                                  imgUrl: service['imgUrl'],
                                ),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteService(dynamic id) async {
    Logger logger = Logger();

    try {
      Query query = FirebaseFirestore.instance.collection('service');

      // Add conditions to your query if any
      if (id != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: id);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      logger.i("Service Deleted!");
    } catch (e) {
      logger.e("Error deleting category", error: e);
    }
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
              const SizedBox(width: 5),
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
                  pageName == "Users" ? Icons.group : Icons.category,
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
