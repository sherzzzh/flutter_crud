import 'package:flutter/material.dart';
import 'package:flutter_crud/mahasiswaInsert.dart';
import 'package:flutter_crud/mahasiswaUpdate.dart';
import 'package:flutter_crud/nilaiMahasiswa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DataMahasiswa extends StatefulWidget {
  const DataMahasiswa({super.key});

  @override
  State<DataMahasiswa> createState() => _DataMahasiswaState();
}

class _DataMahasiswaState extends State<DataMahasiswa> {
  List listMahasiswa = [];

  @override
  void initState() {
    allMahasiswa();
    super.initState();
  }

  Future<void> allMahasiswa() async {
    String urlMahasiswa = "http://192.168.56.1:9001/api/v1/mahasiswa";
    
    try {
      var response = await http.get(Uri.parse(urlMahasiswa));
      listMahasiswa = jsonDecode(response.body);
      setState(() {
        listMahasiswa = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> deleteMahasiwa(int id) async {
    String urlMahasiswa = "http://192.168.56.1:9001/api/v1/mahasiswa/${id}";
    try {
      await http.delete(Uri.parse(urlMahasiswa));
      setState(() {
        allMahasiswa();
      });
    } catch (exc) {
      print(exc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Mahasiswa",
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InsertMahasiswa()))
                    .then((value) => allMahasiswa());
              },
              icon: Icon(
                Icons.person_add_alt_rounded,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
      body: listMahasiswa.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: listMahasiswa.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.pinkAccent,
                      size: 24,
                    ),
                    title: Text(
                      listMahasiswa[index]["nama"]?.toString() ?? "",
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Email : ${listMahasiswa[index]["email"]?.toString() ?? ""}\nTanggal Lahir : ${listMahasiswa[index]["tglLahir"]?.toString() ?? ""}",
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            tooltip: "Lihat Nilai",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NilaiMahasiswa(
                                          listMahasiswa[index]["id"])));
                            },
                            icon: Icon(
                              Icons.grade,
                              color: Colors.pink.shade300,
                              size: 24,
                            )),
                        IconButton(
                            tooltip: "Hapus Data",
                            onPressed: () {
                              deleteMahasiwa(listMahasiswa[index]["id"]);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade300,
                              size: 24,
                            )),
                        IconButton(
                            tooltip: "Edit Data",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UpdateMahasiswa(
                                    listMahasiswa[index]["id"] ?? "",
                                    listMahasiswa[index]["nama"] ?? "",
                                    listMahasiswa[index]["email"] ?? "",
                                    DateTime.parse(
                                        listMahasiswa[index]["tglLahir"]));
                              })).then((value) => allMahasiswa());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.pink.shade800,
                              size: 24,
                            )),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}