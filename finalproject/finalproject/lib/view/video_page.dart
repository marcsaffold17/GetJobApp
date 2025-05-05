import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../model/video_model.dart';
import '../presenter/video_presenter.dart';
import '../repository/video_repository.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> implements VideoView {
  late VideoPresenter _presenter;
  List<VideoModel> _videos = [];
  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _presenter = VideoPresenter(VideoRepository(), this);
    _presenter.loadVideos();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.close();
    }
    super.dispose();
  }

  @override
  void showVideos(List<VideoModel> videos) {
    setState(() {
      _videos = videos;
      _controllers.clear();
      _controllers.addAll(videos.map((video) {
        return YoutubePlayerController.fromVideoId(
          videoId: video.videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            showControls: true,
          ),
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 240),
      appBar: AppBar(
        title: const Text('Interview Prep Videos'),
        backgroundColor: const Color.fromARGB(255, 0, 43, 75),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          final controller = _controllers[index];

          return Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: controller),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
