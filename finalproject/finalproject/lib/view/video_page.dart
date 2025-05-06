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
      backgroundColor: const Color(0xFFF4F3F0),
      appBar: AppBar(
        title: const Text(
          'Interview Prep Videos',
          style: TextStyle(
            color: Color(0xFFF4F3F0),
            fontFamily: 'inter',
          ),
        ),
        backgroundColor: const Color(0xFF002B4B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF4F3F0)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          final controller = _controllers[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF115474),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF002B4B), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: controller),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontFamily: 'JetB',
                      fontSize: 16,
                      color: Color(0xFFF4F3F0),
                    ),
                    textAlign: TextAlign.center,
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
