import '../model/video_model.dart';
import '../repositories/video_repository.dart';

abstract class VideoView {
  void showVideos(List<VideoModel> videos);
}

class VideoPresenter {
  final VideoRepository _repository;
  final VideoView _view;

  VideoPresenter(this._repository, this._view);

  void loadVideos() {
    final videos = _repository.fetchInterviewVideos();
    _view.showVideos(videos);
  }
}
