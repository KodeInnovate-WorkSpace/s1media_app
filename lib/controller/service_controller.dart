import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../model/myservice.dart';

class ServiceController {
  late List<MyService> myServices;
  var logger = Logger();

  Future<List<Map<String, dynamic>>> fetchServiceData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('service').get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      } else {
        logger.w("No service data found");
        return [];
      }
    } catch (e) {
      logger.e("Error fetching service data", error: e);
      rethrow;
    }
  }

  Future<List<MyService>> serviceList() async {
    try {
      List<Map<String, dynamic>> serviceData = await fetchServiceData();

      return serviceData.map((data) {
        // Ensure videoUrls is a List<String>
        List<String> videoUrls;
        if (data['vidUrl'] is String) {
          videoUrls = [data['vidUrl']];
        } else if (data['vidUrl'] is List) {
          videoUrls = List<String>.from(data['vidUrl']);
        } else {
          videoUrls = ["No Video"];
        }

        return MyService(
          imagePath: data['imageUrl'] ?? '',
          title: data['title'] ?? 'No Title',
          subText: data['subText'] ?? 'No sub-text',
          videoUrls: videoUrls,
        );
      }).toList();
    } catch (e) {
      logger.e("Error in serviceList", error: e);
      return [];
    }
  }
}
