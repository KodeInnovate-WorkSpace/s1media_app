import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

// class UserScreen extends StatelessWidget {
//   const UserScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<int> statusOptions = [0, 1];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "User",
//           style: TextStyle(fontFamily: 'cgb'),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.keyboard_backspace),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Expanded(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('users').snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                   child: CircularProgressIndicator(
//                 color: Color(0xffdc3545),
//               ));
//             }
//             final usersData = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: usersData.length,
//               itemBuilder: (context, index) {
//                 final data = usersData[index];
//                 return Dismissible(
//                   key: Key(data.id),
//                   background: Container(
//                     color: const Color(0xffdc3545),
//                     child: const Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   confirmDismiss: (direction) {
//                     return showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         backgroundColor: Colors.white,
//                         title: const Text(
//                           "Delete",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         content: const Text(
//                           "Are you sure you want to delete this?",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         actions: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               TextButton(
//                                 onPressed: () => Navigator.of(context).pop(false),
//                                 style: ButtonStyle(
//                                   overlayColor: WidgetStateProperty.all(Colors.red[900]),
//                                 ),
//                                 child: const Text(
//                                   "No",
//                                   style: TextStyle(
//                                     color: Color(0xffEF4B4B),
//                                   ),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   // await deleteService(data['id']);
//                                   // Get.back();
//                                 },
//                                 style: ButtonStyle(
//                                   overlayColor: WidgetStateProperty.all(Colors.grey[700]),
//                                 ),
//                                 child: const Text(
//                                   "Yes",
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                   child: ListTile(
//                     title: Text(
//                       data['email'],
//                       style: const TextStyle(
//                         fontFamily: 'cgblack',
//                       ),
//                     ),
//                     subtitle: Text(
//                       "Phone: ${data['phone']}",
//                       style: const TextStyle(
//                         fontFamily: 'cgm',
//                       ),
//                     ),
//                     trailing: DropdownButton<int>(
//                       value: data['type'],
//                       iconEnabledColor: const Color(0xffdc3545),
//                       dropdownColor: Colors.white,
//                       onChanged: (int? newValue) {},
//                       items: statusOptions.map<DropdownMenuItem<int>>((int status) {
//                         return DropdownMenuItem<int>(
//                           value: status,
//                           child: Text(
//                             status == 0 ? 'User' : 'Admin',
//                             style: const TextStyle(fontFamily: 'cgb', color: Color(0xffdc3545)),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> statusOptions = [0, 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User",
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
      body: Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xffdc3545),
              ));
            }
            final usersData = snapshot.data!.docs;
            return ListView.builder(
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final data = usersData[index];
                return Dismissible(
                  key: Key(data.id),
                  background: Container(
                    color: const Color(0xffdc3545),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
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
                                  await deleteUser(data['id']);
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
                      data['email'],
                      style: const TextStyle(
                        fontFamily: 'cgblack',
                      ),
                    ),
                    subtitle: Text(
                      "Phone: ${data['phone'] ?? "Unavailable"}",
                      style: const TextStyle(
                        fontFamily: 'cgm',
                      ),
                    ),
                    trailing: DropdownButton<int>(
                      value: data['type'],
                      iconEnabledColor: const Color(0xffdc3545),
                      dropdownColor: Colors.white,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          FirebaseFirestore.instance.collection('users').doc(data.id).update({'type': newValue});
                        }
                      },
                      items: statusOptions.map<DropdownMenuItem<int>>((int status) {
                        return DropdownMenuItem<int>(
                          value: status,
                          child: Text(
                            status == 0 ? 'User' : 'Admin',
                            style: const TextStyle(fontFamily: 'cgb', color: Color(0xffdc3545)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteUser(dynamic id) async {
    Logger logger = Logger();

    try {
      Query query = FirebaseFirestore.instance.collection('users');

      // Add conditions to your query if any
      if (id != null) {
        query = query.where(FieldPath(const ['id']), isEqualTo: id);
      }

      // Get the documents matching the query
      QuerySnapshot querySnapshot = await query.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      logger.i("User Deleted!");
    } catch (e) {
      logger.e("Error deleting user", error: e);
    }
  }
}
