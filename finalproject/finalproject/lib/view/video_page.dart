import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _presenter = VideoPresenter(VideoRepository(), this);
    _presenter.loadVideos();
  }

  @override
  void showVideos(List<VideoModel> videos) {
    setState(() {
      _videos = videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interview Prep Videos')),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: video.videoId,
                    flags: YoutubePlayerFlags(autoPlay: false),
                  ),
                  showVideoProgressIndicator: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(video.title, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
