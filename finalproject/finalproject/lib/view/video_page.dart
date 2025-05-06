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
      _controllers.addAll(
        videos.map((video) {
          return YoutubePlayerController.fromVideoId(
            videoId: video.videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(
              showFullscreenButton: true,
              showControls: true,
            ),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Interview Prep Videos'),
        backgroundColor:
            theme.appBarTheme.backgroundColor ??
            (isDark
                ? const Color.fromARGB(255, 0, 43, 75)
                : const Color.fromARGB(255, 0, 43, 75)),
        foregroundColor: Colors.black ?? Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          final controller = _controllers[index];

          return Card(
            color: theme.cardColor,
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.textTheme.bodyLarge?.color,
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
