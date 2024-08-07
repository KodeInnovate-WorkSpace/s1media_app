import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  final List<String> videos;
  const VideoScreen({super.key, required this.videos});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late List<YoutubePlayerController> videoControllers;
  var logger = Logger();

  @override
  void initState() {
    super.initState();

    videoControllers = widget.videos
        .map((url) {
          final videoId = YoutubePlayer.convertUrlToId(url);
          if (videoId == null) {
            logger.e("Invalid URL: $url");
            return null;
          }
          return YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(hideControls: false, loop: false, autoPlay: false, disableDragSeek: true),
          );
        })
        .whereType<YoutubePlayerController>()
        .toList();
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    // Set preferred orientations back to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: videoControllers.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset("assets/video_placeholder.jpg"),
                  ),
                  const Text(
                    "We are on a shoot!",
                    style: TextStyle(
                      fontFamily: "cgblack",
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "See our work and what we deliver",
                    style: TextStyle(
                      fontFamily: "cgblack",
                      fontSize: 32,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videoControllers.length,
                      itemBuilder: (context, index) {
                        final controller = videoControllers[index];
                        final videoUrl = widget.videos[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  YoutubePlayer(
                                    controller: controller,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.blueAccent,
                                    aspectRatio: 16 / 9,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (await canLaunch(videoUrl)) {
                                          await launch(videoUrl);
                                        } else {
                                          logger.e("Could not launch $videoUrl");
                                        }
                                      },
                                      icon: const Icon(Icons.north_east, color: Colors.white, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
