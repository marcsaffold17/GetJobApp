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
      VideoModel(
        title: 'Top 10 Tech Companies to Work For in 2024',
        videoId: 'OUva5I3n1y8', // Updated list of top tech companies
      ),
      VideoModel(
        title: 'Mock Technical Interview: Software Engineer at Meta',
        videoId: 'gJt4b4cOGXI', // Meta (Facebook) mock interview
      ),
    ];
  }
}
