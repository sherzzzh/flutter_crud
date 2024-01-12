import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertMatakuliah extends StatefulWidget {
  const InsertMatakuliah({super.key});

  @override
  State<InsertMatakuliah> createState() => _InsertMatakuliahState();
}

class _InsertMatakuliahState extends State<InsertMatakuliah> {
  final kode = TextEditingController();
  final nama = TextEditingController();
  final sks = TextEditingController();

  bool isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null || str.isEmpty) {
      return false;
    }
    final format = RegExp(r'^[0-9]+$');
    return format.hasMatch(str);
  }

  Future<void> insertMatakuliah() async {
    if (isNumeric(sks.text)) {
      String urlInsert = "http://192.168.56.1:9002/api/v1/matakuliah";
      final Map<String, dynamic> data = {
        "kode": kode.text,
        "nama": nama.text,
        "sks": int.parse(sks.text)
      };

      try {
        var response = await http.post(Uri.parse(urlInsert),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else {
          print("Gagal");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Bukan Angka");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data Matakuliah"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
          width: 800,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Kode Matakuliah",
                  hintText: "Masukan Kode",
                  prefixIcon: Icon(Icons.qr_code),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: kode,
              ),
              SizedBox(height: 10),
              TextField(
                controller: nama,
                decoration: InputDecoration(
                  labelText: "Nama Matakuliah",
                  hintText: "Masukan Matakuliah",
                  prefixIcon: Icon(Icons.book),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: sks,
                decoration: InputDecoration(
                  labelText: "Jumlah SKS",
                  hintText: "Masukan SKS",
                  prefixIcon: Icon(Icons.numbers),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                  onPressed: () {
                    insertMatakuliah();
                  },
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}