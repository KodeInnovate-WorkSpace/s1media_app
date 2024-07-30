import 'dart:async';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/contact.dart';
import 'package:s1media_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import '../model/myservice.dart';
import '../widget/choose_us_container.dart';
import '../widget/image_container.dart';

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
  AuthController authObj = AuthController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isTextVisible = false;
  int userType = 0;

  @override
  void initState() {
    super.initState();
    _myServices = [
      MyService(
        imagePath: "assets/deal_done_broker.jpeg",
        title: "Deal Done Brokers",
        subText: "Video tours of properties and highlighting unique features and amenities",
        videoUrls: [
          "Link 1",
          "Link 2",
          "Link 3",
          "Link 4",
        ],
      ),
      MyService(
        imagePath: "assets/the_restro.jpeg",
        title: "The Restro",
        subText: "Capturing the ambiance & culinary delights and showcasing special dishes & events",
        videoUrls: [
          "Link 5",
          "Link 6",
          "Link 7",
          "Link 8",
        ],
      ),
      MyService(
        imagePath: "assets/autoz_plus.png",
        title: "Autoz Plus",
        subText: "Updates on new and old cars and bikes, buy and sell opportunities, market trends",
        videoUrls: [],
      ),
      MyService(
        imagePath: "assets/the_foodizz.jpeg",
        title: "The Foodizz",
        subText: "Step-by-step cooking videos and featuring professional chefs and home cooks",
        videoUrls: [],
      ),
      MyService(
        imagePath: "assets/royalz_hotels.jpeg",
        title: "Multi Businesses",
        subText: "Virtual tours of hotel facilities and highlighting services and guest experience",
        videoUrls: [],
      ),
    ];

    _items = _myServices.map((service) => buildImageContainer(service, _myServices)).toList();
    getUserType();
    // Trigger the animation after a short delay
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isTextVisible = true;
      });
    });
  }

  getUserType() async {
    await authObj.retrieveUser();
    int fetchedUserType = (await authObj.userType(authObj.email))!;
    setState(() {
      userType = fetchedUserType;
      log("User Type: $userType");
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
              //logo
              Image.asset(
                "assets/full_logo.png",
                width: 120,
              ),
              const SizedBox(
                height: 30,
              ),

              if (userType == 1)
                //Admin
                InkWell(
                  onTap: () {},
                  splashColor: const Color(0xffdc3545),
                  child: const ListTile(
                    leading: Icon(
                      Icons.data_object_sharp,
                      // size: 18,
                      color: Color(0xffdc3545),
                    ),
                    title: Text(
                      "Admin",
                      style: TextStyle(fontFamily: 'cgb', fontSize: 18),
                    ),
                  ),
                ),

              //Contact us
              InkWell(
                onTap: () {
                  Get.to(() => const ContactScreen());
                },
                splashColor: const Color(0xffdc3545),
                // splashColor: const Color.fromRGBO(255, 20, 0, 100),
                child: const ListTile(
                  leading: Icon(
                    Icons.near_me,
                    // size: 18,
                    color: Color(0xffdc3545),
                  ),
                  title: Text(
                    "Contact Us",
                    style: TextStyle(fontFamily: 'cgb', fontSize: 18),
                  ),
                ),
              ),

              //Logout Button
              InkWell(
                splashColor: const Color(0xffdc3545),
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
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    // size: 18,
                    color: Color(0xffdc3545),
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontFamily: 'cgb', fontSize: 18),
                  ),
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
          child: AnimatedOpacity(
            opacity: _isTextVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Our Service
                const Text(
                  "Our Services",
                  style: TextStyle(
                    fontFamily: "cgblack",
                    fontSize: 35,
                  ),
                ),
                const Text(
                  "At S1Media, we offer a range of services designed to showcase your business",
                  style: TextStyle(fontFamily: "cgm", fontSize: 15, color: Color(0xff8A8B8B)),
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
                const SizedBox(
                  height: 20,
                ),

                buildChooseUsContainer("Free Shooting", "We do not charge for shooting your property or business"),
                const SizedBox(
                  height: 20,
                ),
                buildChooseUsContainer("Free Marketing For 2 Years", "Enjoy two years of free marketing on our YouTube channel and social media"),
                const SizedBox(
                  height: 20,
                ),
                buildChooseUsContainer("Affordable Rates", "After two years, continue your marketing in affordable rates"),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
