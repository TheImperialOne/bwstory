import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'add_data.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
  final String address;

  const VideoPage({Key? key, required this.filePath, required this.address}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
  }

  Future<void> _captureThumbnail() async {
    final thumbnailBytes = await VideoThumbnail.thumbnailData(
      video: widget.filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    setState(() {
      _thumbnailBytes = thumbnailBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await _captureThumbnail(); // Capture thumbnail
              _videoPlayerController.pause();
              _videoPlayerController.setLooping(false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoFormPage(thumbnailBytes: _thumbnailBytes, addressString: widget.address, videoPath: widget.filePath),
                ),
              );
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoPlayerController),
          IconButton(
            icon: Icon(
              _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (_videoPlayerController.value.isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
