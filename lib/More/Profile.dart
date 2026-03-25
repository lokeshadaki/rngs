import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:photo_view/photo_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String gender = "";
  String? imageUrl;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emergencyController = TextEditingController();
  String selectedRelation = "";

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      emailController.text = _user!.email ?? "";
      _loadProfileData();
    }
  }

  Future<void> _loadProfileData() async {
    try {
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(_user!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          firstNameController.text = data['firstName'] ?? "";
          lastNameController.text = data['lastName'] ?? "";
          mobileController.text = data['mobile'] ?? "";
          emergencyController.text = data['emergencyContact'] ?? "";
          gender = data['gender'] ?? "";
          selectedRelation = data['relation'] ?? "";
          imageUrl = data['profileImage'] ?? null;
        });
      }
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  //cloudinary
  Future<void> _uploadImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String? uploadedImageUrl = await _uploadToCloudinary(imageFile);
        if (uploadedImageUrl != null) {
          setState(() {
            imageUrl = uploadedImageUrl;
          });
        } else {
          print("Image upload failed.");
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String?> _uploadToCloudinary(File imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/dmnwyswbc/image/upload');//dmnwyswbc
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'rngs_2'//rngs_2
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      return data['secure_url'];
    } else {
      print("Failed to upload image to Cloudinary: ${response.statusCode}");
      return null;
    }
  }

  Future<void> _submitForm() async {
    String phone = mobileController.text.trim();
    String emergency = emergencyController.text.trim();

    // Validate Mobile Number
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit Mobile Number!")),
      );
      return;
    }

    // Validate Emergency Contact
    if (!RegExp(r'^\d{10}$').hasMatch(emergency)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit Emergency Contact!")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('users').doc(_user!.uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'mobile': phone,
          'email': emailController.text.trim(),
          'gender': gender,
          'emergencyContact': emergency,
          'relation': selectedRelation,
          'profileImage': imageUrl ?? "",
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile Updated!"),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        print("Error saving profile: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY PROFILE",style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (imageUrl != null) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.black,
                                insetPadding: EdgeInsets.zero,
                                child: Stack(
                                  children: [
                                    PhotoView(
                                      imageProvider: NetworkImage(imageUrl!),
                                      backgroundDecoration: BoxDecoration(color: Colors.black),
                                      minScale: PhotoViewComputedScale.contained,
                                      maxScale: PhotoViewComputedScale.covered * 2.5,
                                    ),
                                    Positioned(
                                      top: 30,
                                      right: 20,
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                          child: imageUrl == null
                              ? Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: _uploadImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                buildInputField("First Name *", firstNameController),
                buildInputField("Last Name *", lastNameController),
                buildInputField("Mobile Number *", mobileController,
                    TextInputType.phone),
                buildInputField("Email ID *", emailController,
                    TextInputType.emailAddress, true),
                Text("Gender *", style: TextStyle(color: Colors.black87)),
                Row(
                  children: [
                    buildRadioButton("Male"),
                    buildRadioButton("Female"),
                    buildRadioButton("Others"),
                  ],
                ),
                buildInputField("Emergency Contact *", emergencyController,
                    TextInputType.phone),
                DropdownButtonFormField<String>(
                  value: selectedRelation.isEmpty ? null : selectedRelation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRelation = newValue!;
                    });
                  },
                  items: [
                    "Dad",
                    "Mom",
                    "Brother",
                    "Sister",
                    "Wife",
                    "Friend"
                  ].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: "Select Relation *"),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Relation is required" : null,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      [TextInputType? keyboardType, bool readOnly = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? "$label is required" : null,
      ),
    );
  }

  Widget buildRadioButton(String label) {
    return Row(
      children: [
        Radio(
          value: label,
          groupValue: gender,
          onChanged: (value) => setState(() => gender = value.toString()),
        ),
        Text(label),
      ],
    );
  }
}
