import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:s1media_app/screens/add_service.dart';
import 'package:s1media_app/screens/add_video.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> pages = [
      "Add Service",
      "Add Video",
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Screen",
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: pages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: customContainer(context, pages[index], "p${index + 1}"),
        ),
      ),
    );
  }

  Widget customContainer(BuildContext context, String pageName, String routeName) {
    final Map<String, WidgetBuilder> pageRoutes = {
      'p1': (context) => const AddService(),
      'p2': (context) => const AddVideo(),
    };

    return InkWell(
      onTap: () {
        log("Route Name: $routeName");
        if (pageRoutes.containsKey(routeName)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pageRoutes[routeName]!(context),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Page not found: $pageName'),
              duration: const Duration(milliseconds: 400),
            ),
          );
        }
      },
      child: Container(
        width: 150,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xffdc3545), width: 2.4),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pageName,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xffdc3545), fontFamily: 'cgb', fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
