import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController videoController;

  @override
  void initState() {
    super.initState();

    videoController = YoutubePlayerController(
      // initialVideoId: 'u31qwQUeGuM', // Just the video ID
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    videoController.loadVideo("https://www.youtube.com/watch?v=u31qwQUeGuM");
  }

  @override
  void dispose() {
    videoController.close(); // Dispose of the controller properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            YoutubePlayer(
              controller: videoController,
              aspectRatio: 16 / 9,
            ),
          ],
        ),
      ),
    );
  }
}
