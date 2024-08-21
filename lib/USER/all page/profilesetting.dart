import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:myapp/USER/Screen/LoginScreen.dart';

class Profilesetting extends StatefulWidget {
  const Profilesetting({super.key});

  @override
  State<Profilesetting> createState() => _ProfilesettingState();
}

class _ProfilesettingState extends State<Profilesetting> {
  File? _image;

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
                title: Text("Nama :"),
                subtitle: TextField(),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("No HP :"),
                subtitle: TextField(),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Alamat :"),
                subtitle: TextField(),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text("Email :"),
                subtitle: TextField(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed:
                    _showSaveDialog, // Panggil fungsi dialog saat tombol diklik
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

class Profilepage extends StatefulWidget {
  const Profilepage();

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  File? _profileImage;

  void _handleTileTap(String title) async {
    switch (title) {
      case "Setting":
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profilesetting()),
        );
        if (result != null && result is File) {
          setState(() {
            _profileImage = result;
          });
        }
        break;
      case "Notification":
        // This will be handled by the ExpansionTile
        break;
      case "Logout":
        print("Logging out");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Profil",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // COLUMN THAT WILL CONTAIN THE PROFILE
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/fadli.png'),
              ),
              SizedBox(height: 10),
              Text(
                "Muhammad Chafidzul Fadzi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: tile.title == "Notification"
                      ? ExpansionTile(
                          leading: Icon(tile.icon),
                          title: Text(tile.title),
                          children: [
                            ListTile(
                              leading: Icon(Icons.warning_outlined),
                              title: Text('lengkapi profil anda'),
                              onTap: () {
                                // Handle notification 1 tap
                              },
                            ),
                            ListTile(
                              title: Text('keranjang anda kosong'),
                              onTap: () {
                                // Handle notification 2 tap
                              },
                            ),
                            ListTile(
                              title: Text('cek promo terbaru kami'),
                              onTap: () {
                                // Handle notification 3 tap
                              },
                            ),
                          ],
                        )
                      : ListTile(
                          title: Text(tile.title),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _handleTileTap(tile.title),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.settings_accessibility_outlined,
    title: "Setting",
  ),
  CustomListTile(
    title: "Notification",
    icon: CupertinoIcons.bell,
  ),
  CustomListTile(
    title: "Logout",
    icon: CupertinoIcons.power,
  ),
];
