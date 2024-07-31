import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
        flags: const YoutubePlayerFlags(
          hideControls: false,
          showLiveFullscreenButton: true,
          loop: false,
          autoPlay: false,
        ),
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
        child: Column(
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                      aspectRatio: 16 / 9,
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