import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class Beritapromo extends StatefulWidget {
  @override
  _BeritapromoState createState() => _BeritapromoState();
}

class _BeritapromoState extends State<Beritapromo> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedKategori;
  File? _image;
  final _judulPromoController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _tanggalController = TextEditingController();

  final List<String> _kategoriList = [
    'Beras',
    'Minyak',
    'Susu',
    'Tepung',
    'Kopi',
    'Mie'
  ];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState?.validate() ?? false) {
      var uri = Uri.parse('${dotenv.env['ENDPOINT']}/upload.php');
      
      var request = http.MultipartRequest('POST', uri);
      
      // Tambahkan file gambar jika ada
      if (_image != null) {
        var stream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(_image!.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      // Tambahkan data form
      request.fields['judul_promo'] = _judulPromoController.text;
      request.fields['tanggal_promo'] = _tanggalController.text;
      request.fields['isi_promo'] = _deskripsiController.text;
      request.fields['harga_promo'] = _hargaController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan!')),
        );
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Berita & Promo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 46, 38, 95),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedKategori,
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Pilih Kategori', style: TextStyle(color: Colors.white)),
                      ),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedKategori = newValue;
                        });
                      },
                      items: _kategoriList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(value, style: TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.grey[500],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _judulPromoController,
                  decoration: InputDecoration(
                    labelText: 'Judul Promo',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => value == null || value.isEmpty ? 'Judul Promo tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _hargaController,
                  decoration: InputDecoration(
                    labelText: 'Harga Promo',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Harga Promo tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _tanggalController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Promo',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      setState(() {
                        _tanggalController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Tanggal Promo tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                ),
                SizedBox(height: 16.0),
                _image == null
                    ? Text('Tidak ada gambar yang dipilih.', style: TextStyle(color: Colors.white))
                    : Image.file(_image!),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(218, 251, 138, 0),
                      ),
                      onPressed: _pickImage,
                      child: Text('Upload Gambar', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: _uploadData,
                      child: Text('Kirim'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
