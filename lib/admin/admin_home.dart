import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/admin/admin_alarm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false; // Track upload state

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> addContentToHomepage(String collectionName) async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (selectedImage == null || title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Please select an image and fill title and description!")),
      );
      return;
    }

    setState(() {
      isUploading = true; // Show progress indicator
    });

    try {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      await FirebaseFirestore.instance.collection(collectionName).add({
        'title': title,
        'description': description,
        'imageURL': downloadUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Content added successfully!")),
      );

      // Clear fields after adding
      titleController.clear();
      descriptionController.clear();
      selectedImage = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add content: $e")),
      );
    } finally {
      setState(() {
        isUploading = false; // Hide progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: getImage,
                child: selectedImage == null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: 20),
              if (isUploading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => addContentToHomepage('ngo_content'),
                      child: Text("Add to NGOs"),
                    ),
                    ElevatedButton(
                      onPressed: () => addContentToHomepage('safety_content'),
                      child: Text("Add to Safety"),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          addContentToHomepage('awareness_content'),
                      child: Text("Add to Awareness"),
                    ),
                  ],
                ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminAlarmPage()));
                },
                child: Text(
                  "Alert Alarm",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
