import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KycPage extends StatefulWidget {
  @override
  _KycPageState createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  File? _licenseImage;
  File? _aadharImage;
  final _licenseController = TextEditingController();
  final _aadharController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _auth = FirebaseAuth.instance;

  String? licenseUrl;
  String? aadharUrl;

  String? licenseImage;
  String? aadharImage;
  @override
  void initState() {
    super.initState();
    _fetchKycData();
  }

  Future<void> _fetchKycData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('kyc').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _licenseController.text = data['licenseId'] ?? '';
          _aadharController.text = data['aadharId'] ?? '';
          licenseImage = data['licenseImage'] ?? '';
          aadharImage = data['aadharImage'] ?? '';
        });
      }
    }
  }

  Future<String?> _uploadToCloudinary(File imageFile) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/dmnwyswbc/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'rngs_1'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _pickImage(bool isLicense) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isLicense) {
          _licenseImage = File(image.path);
        } else {
          _aadharImage = File(image.path);
        }
      });
    }
  }

  Future<void> _submitKyc() async {
    String licenseId = _licenseController.text.trim();
    String aadharId = _aadharController.text.trim();

    final licenseRegEx = RegExp(r'^[A-Z]{2}\d{2}\d{11}$');

    final aadharRegEx = RegExp(r'^\d{12}$');

    if (!licenseRegEx.hasMatch(licenseId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Driving License Format!")),
      );
      return;
    }

    if (!aadharRegEx.hasMatch(aadharId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aadhar must be a 12-digit number!")),
      );
      return;
    }

    if ((_licenseImage == null && licenseUrl == null) || (_aadharImage == null && aadharUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload both images!")),
      );
      return;
    }

    if (_licenseImage != null) {
      licenseUrl = await _uploadToCloudinary(_licenseImage!);
    }
    if (_aadharImage != null) {
      aadharUrl = await _uploadToCloudinary(_aadharImage!);
    }

    final user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('kyc').doc(user.uid).set({
        'licenseId': licenseId,
        'aadharId': aadharId,
        'licenseImage': licenseUrl ?? '',
        'aadharImage': aadharUrl ?? '',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("KYC Submitted Successfully!")),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed!")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KYC Verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageDisplay(
              label: "Driving License",
              imageUrl: licenseImage,
              localImage: _licenseImage,
              onTap: () => _pickImage(true),
            ),
            SizedBox(height: 10),
            _buildTextField("Driving License Number", _licenseController),
            SizedBox(height: 20),
            _buildImageDisplay(
              label: "Aadhar Card",
              imageUrl: aadharImage,
              localImage: _aadharImage,
              onTap: () => _pickImage(false),
            ),
            SizedBox(height: 10),
            _buildTextField("Aadhar Card Number ", _aadharController),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitKyc,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text("Submit KYC", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay({required String label, String? imageUrl, File? localImage, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: localImage != null
                  ? FileImage(localImage) as ImageProvider
                  : (imageUrl != null && imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null), // Fixed network image logic
              child: (localImage == null && (imageUrl == null || imageUrl.isEmpty))
                  ? Icon(Icons.camera_alt, color: Colors.blueGrey)
                  : null, // Show icon only if no image exists
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: onTap,
              child: Text("Select Image", style: TextStyle(color: Colors.blueGrey)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
