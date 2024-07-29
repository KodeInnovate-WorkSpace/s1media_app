import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/enquire_form.dart';
import 'package:s1media_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';
import '../model/myservice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  late List<Widget> _items;
  late List<MyService> _myServices;
  UserController userObj = UserController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isTextVisible = false;

  @override
  void initState() {
    super.initState();
    _myServices = [
      MyService(
        imagePath: "assets/deal_done_broker.jpeg",
        title: "Deal Done Brokers",
        subText: "Video tours of properties and highlighting unique features and amenities",
      ),
      MyService(
        imagePath: "assets/the_restro.jpeg",
        title: "The Restro",
        subText: "Capturing the ambiance & culinary delights and showcasing special dishes & events",
      ),
      MyService(
        imagePath: "assets/autoz_plus.png",
        title: "Autoz Plus",
        subText: "Updates on new and old cars and bikes, buy and sell opportunities, market trends",
      ),
      MyService(
        imagePath: "assets/the_foodizz.jpeg",
        title: "The Foodizz",
        subText: "Step-by-step cooking videos and featuring professional chefs and home cooks",
      ),
      MyService(
        imagePath: "assets/royalz_hotels.jpeg",
        title: "Multi Businesses",
        subText: "Virtual tours of hotel facilities and highlighting services and guest experience",
      ),
    ];

    _items = _myServices.map((service) => buildImageContainer(service)).toList();

    // Trigger the animation after a short delay
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          // Menu Icon
          GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                "assets/menu.png",
                fit: BoxFit.contain,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
        title: Image.asset(
          "assets/full_logo.png",
          width: 120,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          child: Column(
            children: [
              Image.asset(
                "assets/full_logo.png",
                width: 120,
              ),
              const SizedBox(
                height: 30,
              ),
              //Contact us
              const ListTile(
                leading: Icon(
                  Icons.contact_page,
                  // size: 18,
                  color: Color(0xffdc3545),
                ),
                title: Text(
                  "Contact Us",
                  style: TextStyle(fontFamily: 'cgb', fontSize: 18),
                ),
              ),

              //Logout Button
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.black),
                            ),
                            content: const Text(
                              "Are you sure you want to logout?",
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(Colors.red[900]),
                                      ),
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                          color: Color(0xffEF4B4B),
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.remove('isLoggedIn');
                                        Get.offAll(() => const LoginScreen());
                                      },
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(Colors.grey[700]),
                                      ),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ],
                              )
                            ],
                          ));
                },
                leading: const Icon(
                  Icons.logout,
                  // size: 18,
                  color: Color(0xffdc3545),
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(fontFamily: 'cgb', fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Our Service
              AnimatedOpacity(
                opacity: _isTextVisible ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Services",
                      style: TextStyle(
                        fontFamily: "cgblack",
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      "At S1Media, we offer a range of services designed to showcase your business",
                      style: TextStyle(fontFamily: "cgm", fontSize: 15, color: Color(0xff8A8B8B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Slider
              CarouselSlider(
                  items: _items,
                  options: CarouselOptions(
                    height: 380.0,
                    autoPlay: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  )),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _items.map((item) {
                  int index = _items.indexOf(item);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _current == index ? const Color(0xffBA1D17) : const Color(0xffD9D9D9)),
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                "Why Choose Us?",
                style: TextStyle(
                  fontFamily: "cgblack",
                  fontSize: 32,
                ),
              ),
              const Text(
                "We do not charge for shooting your property or business",
                style: TextStyle(fontFamily: "cgm", fontSize: 15, color: Color(0xff8A8B8B)),
              ),
              const Text(
                "Enjoy two years of free marketing on our YouTube channel and social media",
                style: TextStyle(fontFamily: "cgm", fontSize: 15, color: Color(0xff8A8B8B)),
              ),
              const Text(
                "After two years, continue your marketing",
                style: TextStyle(fontFamily: "cgm", fontSize: 15, color: Color(0xff8A8B8B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageContainer(MyService service) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        color: Colors.grey[100],
        image: DecorationImage(
          image: AssetImage(service.imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.2),
                  height: 158,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        service.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "cgblack",
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Sub-text
                      Text(
                        service.subText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "cgb",
                        ),
                      ),
                      // Enquire button
                      Center(
                        child: OutlinedButton(
                          onPressed: () async {
                            HapticFeedback.selectionClick();
                            Get.to(
                              () => EnquireForm(serviceName: service.title, services: _myServices.map((s) => s.title).toList()),
                              // transition: Transition.rightToLeft,
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 500),
                              // curve: Curves.easeInOut,
                            );
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: Color(0xffBA1D17), // Set the border color
                                width: 2.5, // Set the border width
                              ),
                            ),
                          ),
                          child: const Text(
                            "Enquire",
                            style: TextStyle(color: Colors.white, fontFamily: 'cgblack'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
