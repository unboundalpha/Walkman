import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SimpleAudioPlayer {
  static SimpleAudioPlayer? _instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration totalDuration = Duration();
  Duration elapsedDuration = Duration();
  double get playbackPosition =>
      _audioPlayer.position.inMilliseconds.toDouble();
  VoidCallback? onPlayFromUrlCallback;
  void Function(double percentage, Duration elapsed)?
      onTimeElapsedPercentageCallback;
  StreamController<bool> _isPlayingController =
      StreamController<bool>.broadcast();
  StreamController<double> _playbackPositionController =
      StreamController<double>.broadcast();

  SimpleAudioPlayer._internal();

  factory SimpleAudioPlayer() {
    _instance ??= SimpleAudioPlayer._internal();
    return _instance!;
  }

  Stream<bool> get isPlayingStream => _isPlayingController.stream;
  Stream<double> get playbackPositionStream =>
      _playbackPositionController.stream;

  AudioPlayer get audioPlayerInstance => _audioPlayer;

  Future<void> playFromUrl(String url) async {
    await _audioPlayer.setUrl(url);
    await _audioPlayer.play();
    isPlaying = true;
    _isPlayingController.add(isPlaying);

    totalDuration = _audioPlayer.duration ?? Duration.zero;

    if (onPlayFromUrlCallback != null) {
      onPlayFromUrlCallback!();
    }

    _startUpdatingPlaybackPosition();
  }

  void pause() {
    _audioPlayer.pause();
    isPlaying = false;
    _isPlayingController.add(isPlaying);
  }

  void resume() {
    _audioPlayer.play();
    isPlaying = true;
    _isPlayingController.add(isPlaying);
  }

  void stop() {
    _audioPlayer.stop();
    isPlaying = false;
    elapsedDuration = Duration();
    _isPlayingController.add(isPlaying);
    _stopUpdatingPlaybackPosition();
  }

  String getTotalDuration() {
    int minutes = totalDuration.inMinutes;
    int seconds = (totalDuration.inSeconds % 60).toInt();
    String td = '$minutes:${seconds < 10 ? '0$seconds' : '$seconds'}';
    return td;
  }

  Duration getElapsedDuration() {
    return elapsedDuration;
  }

  void dispose() {
    _audioPlayer.dispose();
    _isPlayingController.close();
    _playbackPositionController.close();
    _stopUpdatingPlaybackPosition();
  }

  void updateElapsedDuration(Duration position) {
    elapsedDuration = position;
    double percentage =
        elapsedDuration.inMilliseconds / totalDuration.inMilliseconds * 100.0;
    if (onTimeElapsedPercentageCallback != null) {
      onTimeElapsedPercentageCallback!(percentage, elapsedDuration);
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    updateElapsedDuration(position);
  }

  void _startUpdatingPlaybackPosition() {
    _audioPlayer.positionStream.listen((event) {
      updateElapsedDuration(event);
      _playbackPositionController.add(playbackPosition);
    });
  }

  void _stopUpdatingPlaybackPosition() {
    _playbackPositionController.close();
  }

  void setOnPlayFromUrlCallback(VoidCallback callback) {
    onPlayFromUrlCallback = callback;
  }

  void setOnTimeElapsedPercentageCallback(
      void Function(double percentage, Duration elapsed) callback) {
    onTimeElapsedPercentageCallback = callback;
  }
}
