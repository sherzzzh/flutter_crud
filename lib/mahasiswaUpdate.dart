import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UpdateMahasiswa extends StatefulWidget {
  int idup;
  String namaup;
  String emailup;
  DateTime tglLahirup;
  UpdateMahasiswa(this.idup, this.namaup, this.emailup, this.tglLahirup);

  @override
  State<UpdateMahasiswa> createState() => _UpdateMahasiswaState();
}

class _UpdateMahasiswaState extends State<UpdateMahasiswa> {
  int id = 0;
  final nama = TextEditingController();
  final email = TextEditingController();
  DateTime tglLahir = DateTime.now();

  @override
  void initState() {
    nama.text = widget.namaup;
    email.text = widget.emailup;
    tglLahir = widget.tglLahirup;
    id = widget.idup;

    super.initState();
  }

  Future<void> _pilihTgl(BuildContext context) async {
    final DateTime? kalender = await showDatePicker(
        context: context,
        initialDate: tglLahir,
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));

    if (kalender != null && kalender != tglLahir) {
      setState(() {
        tglLahir = kalender;
      });
    }
  }

  Future<void> updateMahasiswa() async {
    String urlInsert =
        "http://192.168.56.1:9001/api/v1/mahasiswa/${id}?nama=${nama.text}&&email=${email.text}&&tglLahir=${"${tglLahir.toLocal()}".split(" ")[0]}";

    try {
      var response = await http.put(
        Uri.parse(urlInsert),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Data Mahasiswa"),
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
                controller: nama,
                decoration: InputDecoration(
                  labelText: "Nama",
                  hintText: "Ketikkan Nama",
                  prefixIcon: Icon(Icons.text_fields),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Ketikkan Email",
                  prefixIcon: Icon(Icons.email_rounded),
                  fillColor: Colors.pink.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  hintText: "Pilih Tanggal Lahir",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.pink.shade200,
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pilihTgl(context),
                controller: TextEditingController(
                  text: "${tglLahir.toLocal()}".split(" ")[0],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                  ),
                  onPressed: () => updateMahasiswa(),
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