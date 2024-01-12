import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class UpdateNilai extends StatefulWidget {
  int idup;
  int idMhsup;
  int idMkup;
  double nilaiup;
  UpdateNilai(this.idup, this.idMhsup, this.idMkup, this.nilaiup);

  @override
  State<UpdateNilai> createState() => _UpdateNilaiState();
}

class _UpdateNilaiState extends State<UpdateNilai> {
  List<Map<String, dynamic>> namaMahasiswa = [];
  List<Map<String, dynamic>> namaMatakuliah = [];
  int? idMahasiswa;
  int? idMatakuliah;

  final nilai = TextEditingController();
  int id = 0;

  @override
  void initState() {
    idMahasiswa = widget.idMhsup;
    idMatakuliah = widget.idMkup;
    nilai.text = widget.nilaiup.toString();
    id = widget.idup;
    super.initState();
    getMahasiswa();
    getMatakuliah();
  }

  bool isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null || str.isEmpty) {
      return false;
    }

    final format = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    return format.hasMatch(str);
  }

  Future<void> updateNilai() async {
    if (isNumeric(nilai.text)) {
      String urlUpdate =
          "http://192.168.56.1:9003/api/v1/nilai/${id}?idMahasiswa=${idMahasiswa}&idMatakuliah=${idMatakuliah}&nilai=${nilai.text}";

      try {
        var response = await http.put(Uri.parse(urlUpdate));
        if (response.statusCode == 200) {
          print(urlUpdate);
          Navigator.pop(context);
        } else {
          print(response.body);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Bukan Angka Desimal");
    }
  }

  Future<void> getMahasiswa() async {
    String urlMahasiswa = "http://192.168.56.1:9001/api/v1/mahasiswa";
    try {
      var response = await http.get(Uri.parse(urlMahasiswa));
      final List<dynamic> dataMhs = jsonDecode(response.body);
      setState(() {
        namaMahasiswa = List.from(dataMhs);
      });
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> getMatakuliah() async {
    String urlMatakuliah = "http://192.168.56.1:9002/api/v1/matakuliah";
    try {
      var response = await http.get(Uri.parse(urlMatakuliah));
      final List<dynamic> dataMk = jsonDecode(response.body);
      setState(() {
        namaMatakuliah = List.from(dataMk);
      });
    } catch (exc) {
      print(exc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Nilai"),
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
              DropdownButtonFormField(
                value: idMahasiswa?.toString(),
                onChanged: (value) {
                  setState(() {
                    idMahasiswa = int.parse(value.toString());
                  });
                },
                items: namaMahasiswa.map((item) {
                  return DropdownMenuItem(
                      value: item["id"].toString(), child: Text(item["nama"]));
                }).toList(),
                decoration: InputDecoration(
                  labelText: "ID Mahasiswa",
                  hintText: "Pilih Mahasiswa",
                  prefixIcon: Icon(Icons.person_pin_outlined),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: idMatakuliah?.toString(),
                onChanged: (value) {
                  setState(() {
                    idMatakuliah = int.parse(value.toString());
                  });
                },
                items: namaMatakuliah.map((item) {
                  return DropdownMenuItem(
                      value: item["id"].toString(),
                      child: Text(item["nama"].toString()));
                }).toList(),
                decoration: InputDecoration(
                  labelText: "ID Matakuliah",
                  hintText: "Pilih Matakuliah",
                  prefixIcon: Icon(Icons.bookmark_border),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nilai,
                decoration: InputDecoration(
                  labelText: "Nilai",
                  hintText: "Ketikkan Jumlah Nilai",
                  prefixIcon: Icon(Icons.numbers_rounded),
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
                    backgroundColor: Colors.pinkAccent.shade400,
                  ),
                  onPressed: () {
                    updateNilai();
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