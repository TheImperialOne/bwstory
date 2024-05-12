import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import '../video.dart';

class VideoFormPage extends StatefulWidget {
  final Uint8List? thumbnailBytes; // Pass the thumbnail bytes as a parameter
  final String addressString;
  final String videoPath;

  const VideoFormPage(
      {Key? key,
      this.thumbnailBytes,
      required this.addressString,
      required this.videoPath})
      : super(key: key);

  @override
  _VideoFormPageState createState() => _VideoFormPageState();
}

class _VideoFormPageState extends State<VideoFormPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _selectedCategory = '';

  List<String> _categories = [
    'General',
    'Discussion',
    'Meme',
    'Political',
    'Photography',
    'Event',
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Add Video',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Thumbnail:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (widget.thumbnailBytes != null)
                    Image.memory(widget.thumbnailBytes!),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: widget.addressString,
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value:
                        _selectedCategory.isNotEmpty ? _selectedCategory : null,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.toLowerCase(),
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          print('Title: $_title');
                          print('Description: $_description');
                          print('Category: $_selectedCategory');
                          Video newVideo = Video(
                            videoURL: widget.videoPath,
                            // Assuming widget.addressString contains the path to the video
                            title: _title,
                            description: _description,
                            location: widget.addressString,
                            // You can add a location field to the form and retrieve its value here
                            category: _selectedCategory,
                          );
                          File videoFile = File(widget
                              .videoPath); // Assuming widget.addressString contains the path to the video file
                          await uploadVideoAndMetadata(videoFile, widget.thumbnailBytes!, newVideo);
                          setState(() => _isLoading = false);
                          Navigator.pushNamed(context, 'success');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                      ),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> uploadVideoAndMetadata(File videoFile, Uint8List thumbnailBytes, Video video) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? phoneNumber = user?.phoneNumber;

      // Upload video file to Firebase Storage
      String videoFileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference videoRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('videos')
          .child(phoneNumber!+videoFileName + '.mp4');
      await videoRef.putFile(videoFile);

      // Upload thumbnail image to Firebase Storage
      String thumbnailFileName = '$phoneNumber'+'$videoFileName.jpg'; // Assuming thumbnail format is JPEG
      firebase_storage.Reference thumbnailRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('thumbnails')
          .child(thumbnailFileName);
      await thumbnailRef.putData(thumbnailBytes);

      // Get the download URLs of the uploaded files
      String videoDownloadURL = await videoRef.getDownloadURL();
      String thumbnailDownloadURL = await thumbnailRef.getDownloadURL();

      // Create a JSON object with the video metadata
      Map<String, dynamic> videoMetadata = {
        'title': video.title,
        'description': video.description,
        'location': video.location,
        'category': video.category,
        'videoURL': videoDownloadURL,
        'thumbnailURL': thumbnailDownloadURL, // Add thumbnail URL to metadata
      };

      // Convert the JSON object to a string
      String jsonString = json.encode(videoMetadata);

      // Upload the JSON object as a file to Firebase Storage
      firebase_storage.Reference metadataRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('metadata')
          .child(phoneNumber!+videoFileName + '.json');
      await metadataRef.putData(Uint8List.fromList(utf8.encode(jsonString)));

      print('Video, thumbnail, and metadata uploaded to Firebase Storage successfully!');
    } catch (e) {
      print('Error uploading video, thumbnail, and metadata to Firebase Storage: $e');
    }
  }
}
