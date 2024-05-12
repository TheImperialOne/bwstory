import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:bwstory/record-video/video_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../geolocator.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  late String _address;

  @override
  void initState() {
    super.initState();
    _initCamera(); // Preload camera
    _address = 'Fetching address...';
    _fetchAddress();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }
  Future<void> _fetchAddress() async {
    try {
      Position position = await GeolocationData.getCurrentLocation();
      // Use the fetched position to fetch the address
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          print("Address: "+_address);
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Address not available';
      });
      print("Error fetching address: $e");
    }
  }
  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path,address: _address,),
      );
      Navigator.push(context, route);

      // Fetch location
      Position? position = await _getLocation();
      if (position != null) {
        GeolocationData.currentPosition = position;
      }
    } else {
      // Fetch location
      Position? position = await _getLocation();
      if (position != null) {
        GeolocationData.currentPosition = position;
      }

      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }
  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle appropriately.
      return null;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, display a dialog to the user.
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  _switchCamera() async {
    final cameras = await availableCameras();
    final newCamera = _cameraController.description == cameras[0] ? cameras[1] : cameras[0];
    await _cameraController.dispose();
    _cameraController = CameraController(newCamera, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() {});
  }

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
      return Stack(
        children: [
          CameraPreview(_cameraController),
          Positioned(
            bottom: 25,
            left: MediaQuery.of(context).size.width * 0.5 - 25, // Center record button
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _recordVideo,
              child: Icon(_isRecording ? Icons.stop : Icons.circle),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 25,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: _switchCamera,
              mini: true, // Reduce the size of the switch button
              child: Icon(Icons.switch_camera),
            ),
          ),
        ],
      );
    }
  }
}