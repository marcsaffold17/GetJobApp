import '../model/video_model.dart';

class VideoRepository {
  List<VideoModel> fetchInterviewVideos() {
    return [
      VideoModel(
        title: 'Google Coding Interview With A Normal Software Engineer',
        videoId: 'XKu_SEDAykw', // Verified working
      ),
      VideoModel(
        title: 'Amazon Coding Interview Preparation',
        videoId: 'aClxtDcdpsQ', // Amazon mock interview with engineer
      ),
      VideoModel(
        title: 'How to Prepare for a Coding Interview | Google Engineer',
        videoId: 'rEJzOhC5ZtQ', // Real tips from ex-Googler
      ),


    ];
  }
}
