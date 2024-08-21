import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class Profilesetting extends StatefulWidget {
  const Profilesetting({super.key});

  @override
  State<Profilesetting> createState() => _ProfilesettingState();
}

class _ProfilesettingState extends State<Profilesetting> {
  File? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _showSaveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Disimpan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Perubahan profil Anda telah disimpan.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(
                    context, _image); // Return to ProfilePage with the image
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
        title: const Text("Edit Profil",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Foto"),
                subtitle: Column(
                  children: [
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 100,
                            width: 170,
                          )
                        : Image.asset(
                            "assets/editAkun.png",
                            height: 100,
                            width: 170,
                          ),
                    SizedBox(height: 10), // Jarak antara gambar dan tombol
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        fixedSize: Size(double.infinity, 40),
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Username :"),
                subtitle: TextField(
                  controller: _usernameController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Password :"),
                subtitle: TextField(
                  controller: _passwordController,
                  obscureText: true, // Hide password
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Nama :"),
                subtitle: TextField(
                  controller: _nameController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("No HP :"),
                subtitle: TextField(
                  controller: _phoneController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Alamat :"),
                subtitle: TextField(
                  controller: _addressController,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Email :"),
                subtitle: TextField(
                  controller: _emailController,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _showSaveDialog, // Panggil fungsi dialog saat tombol diklik
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(243, 162, 11, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  fixedSize: Size(double.infinity, 50),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
