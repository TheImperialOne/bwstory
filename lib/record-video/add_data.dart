import 'package:flutter/material.dart';

class VideoFormPage extends StatefulWidget {
  const VideoFormPage({Key? key}) : super(key: key);

  @override
  _VideoFormPageState createState() => _VideoFormPageState();
}

class _VideoFormPageState extends State<VideoFormPage> {
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
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30), // Add space at the top
              Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20), // Add space between title and form
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(), // Add border
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
              SizedBox(height: 20), // Add space between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(), // Add border
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
              SizedBox(height: 20), // Add space between fields
              DropdownButtonFormField<String>(
                value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(), // Add border
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
              SizedBox(height: 20), // Add space between fields
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, submit data
                    // You can access _title, _description, and _selectedCategory here
                    // For example:
                    print('Title: $_title');
                    print('Description: $_description');
                    print('Category: $_selectedCategory');
                    // Add code to save data to Firebase or perform any other actions
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
