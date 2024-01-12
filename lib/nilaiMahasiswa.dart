import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class NilaiMahasiswa extends StatefulWidget {
  int idAll;
  NilaiMahasiswa(this.idAll);

  @override
  State<NilaiMahasiswa> createState() => _NilaiMahasiswaState();
}

class _NilaiMahasiswaState extends State<NilaiMahasiswa> {
  List listSemua = [];
  int id = 0;
  @override
  void initState() {
    super.initState();
    id = widget.idAll;
    mahasiswaAll();
  }

  Future<void> mahasiswaAll() async {
    String urlAll = "http://192.168.56.1:9003/api/v1/nilai/$id";
    try {
      var response = await http.get(Uri.parse(urlAll));
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        listSemua = List.from(data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Nilai Mahasiswa"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: listSemua.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: listSemua.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(
                      Icons.pin_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                    title: Text(
                      listSemua[index]["mahasiswa"]["nama"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Matakuliah : ${listSemua[index]["matakuliah"]["nama"]} \nNilai : ${listSemua[index]["nilai"]["nilai"]}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                );
              }),
    );
  }
}