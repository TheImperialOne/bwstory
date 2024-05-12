import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color as needed
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0), // Add margin
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search', // Placeholder text
            prefixIcon: Icon(Icons.search), // Search icon
            border: OutlineInputBorder(), // Border for the text field
          ),
          onChanged: (value) {
            // Perform search action here based on the value entered
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
