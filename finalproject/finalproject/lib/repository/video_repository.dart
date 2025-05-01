import '../model/video_model.dart';

class VideoRepository {
  List<VideoModel> fetchInterviewVideos() {
    return [
      VideoModel(
        title: 'Google Coding Interview With A Normal Software Engineer',
        videoId: 'XKu_SEDAykw',
      ),
      VideoModel(
        title: 'Top 10 Tech Companies to Work For',
        videoId: 'wz3Gagk9GXI',
      ),
      VideoModel(
        title: 'How to Prepare for Job Interviews',
        videoId: 'n9b5wQx6jWc',
      ),
      // Add more as needed
    ];
  }
}
