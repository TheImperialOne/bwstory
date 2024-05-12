import 'dart:convert';
import 'dart:typed_data';

import 'package:bwstory/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VideoData {
  final String thumbnailUrl;
  final String title;
  final String videoUrl;
  final String description;
  final String location;
  final String category;

  VideoData({
    required this.thumbnailUrl,
    required this.title,
    required this.videoUrl,
    required this.description,
    required this.location,
    required this.category,
  });
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<VideoData> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideoMetadata();
  }

  Future<void> fetchVideoMetadata() async {
    try {
      // Get a reference to the metadata folder
      firebase_storage.ListResult metadataResult =
      await firebase_storage.FirebaseStorage.instance.ref('metadata').listAll();

      List<VideoData> videos = [];

      // Iterate through each metadata file
      for (firebase_storage.Reference metadataRef in metadataResult.items) {
        if (metadataRef.name != null) {
          // Fetch metadata from the file
          Map<String, dynamic> metadataMap = await fetchMetadata(metadataRef.name!);

          // Extract title and thumbnail URL
          String title = metadataMap['title'] ?? ''; // Provide a default value if 'title' is null
          String thumbnailUrl = metadataMap['thumbnailURL'] ?? ''; // Correct key to match the one used in storing the thumbnail URL
          String videoUrl = metadataMap['videoURL'] ?? '';
          String description = metadataMap['description'] ?? '';
          String location = metadataMap['location'] ?? '';
          String category = metadataMap['category'] ?? '';

          videos.add(VideoData(
            thumbnailUrl: thumbnailUrl,
            title: title,
            videoUrl: videoUrl,
            description: description,
            location: location,
            category: category,
          ));
        }
      }

      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching video metadata: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchMetadata(String metadataName) async {
    try {
      // Get a reference to the metadata file and fetch the data
      firebase_storage.Reference metadataRef =
      firebase_storage.FirebaseStorage.instance.ref('metadata').child(metadataName);
      firebase_storage.FullMetadata metadata = await metadataRef.getMetadata();
      Uint8List? metadataBytes = await metadataRef.getData(metadata.size!);

      // Decode the Uint8List into a String
      String metadataString = utf8.decode(metadataBytes!);

      // Parse the JSON string into a Map<String, dynamic>
      return json.decode(metadataString);
    } catch (e) {
      print('Error fetching metadata: $e');
      return {}; // Return an empty map if metadata fetching fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50), //
          Text(
            'Explore',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoUrl: video.videoUrl,
                          title: video.title,
                          description: video.description,
                          location: video.location,
                          category: video.category,
                        ),
                      ),
                    );
                  },
                  child: VideoTile(video: video),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final VideoData video;
  final double padding;

  const VideoTile({Key? key, required this.video, this.padding = 8.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9, // Set aspect ratio to 16:9
            child: Image.network(
              video.thumbnailUrl,
              fit: BoxFit.cover, // Ensure the image covers the entire container
            ),
          ),
          SizedBox(height: 10),
          Text(
            video.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
