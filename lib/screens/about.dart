import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void myLaunchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/full_logo.png",
          width: 120,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Expertise in Digital, Design & Development",
                style: TextStyle(
                  fontFamily: "cgblack",
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '''S1MEDIA is a dynamic media company dedicated to helping businesses in the real estate, restaurant, culinary, old or new car deals and hospitality enhance their online presence. Our team of skilled shooting editors travels to your location to create stunning video content that we share across on our YouTube channel and social media platforms.
                ''',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18, fontFamily: 'cgm'),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact",
                    style: TextStyle(fontFamily: 'cgblack', fontSize: 20),
                  ),
                  ListTile(
                    leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffdc3545),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.email,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                    title: const Text("info@s1media.in", style: TextStyle(color: Color(0xff666666), fontFamily: 'cgb')),
                    onTap: () async {
                      Uri email = Uri(scheme: 'mailto', path: "info@s1media.in");
                      await launchUrl(email);
                    },
                  ),
                  ListTile(
                    leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffdc3545),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                    title: const Text("+91 9326500602", style: TextStyle(color: Color(0xff666666), fontFamily: 'cgb')),
                    onTap: () async {
                      Uri dialNumber = Uri(scheme: 'tel', path: "9326500602");
                      await launchUrl(dialNumber);
                    },
                  ),
                  ListTile(
                    leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffdc3545),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                    title: const Text("s1media.in", style: TextStyle(color: Color(0xff666666), fontFamily: 'cgb')),
                    onTap: () {
                      myLaunchURL('https://www.s1media.in/');
                    },
                  ),
                  ListTile(
                    leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffdc3545),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.apartment,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                    title: const Text("S1Media, Kalyan phata near HP oil petrol pump - 421208", style: TextStyle(color: Color(0xff666666), fontFamily: 'cgb')),
                  ),
                ],
              ),

              const Divider(),

              // Privacy
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'cgm'),
                ),
                onTap: () {
                  myLaunchURL("https://kodeinnovate-workspace.github.io/s1media_policy/privacy_policy.html");
                },
              ),

              //Terms
              ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'cgm'),
                ),
                onTap: () {
                  myLaunchURL("https://kodeinnovate-workspace.github.io/s1media_policy/terms.html");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
