import 'dart:convert'; //Mengimpor data JSON.

import 'package:flutter/material.dart'; //Mengimpor pustaka Flutter untuk membuat antarmuka pengguna (UI).

void main() => runApp(MyApp()); //memulai aplikasi Flutter

class MyApp extends StatelessWidget {
  //mendefinisikan widget
  @override
  Widget build(BuildContext context) {
    //mendefinisikan ui aplikasi
    return MaterialApp(
      //konfigurasi widget root
      title: 'Hasil IPK', //judul
      theme: ThemeData(
        //tema aplikasi
        primarySwatch: Colors.blue, //warna bviru
      ),
      home: MyHomePage(),

      ///mengatur halaman utama
    );
  }
}

class MyHomePage extends StatefulWidget {
  //mendefinisikan widget
  @override
  _MyHomePageState createState() => _MyHomePageState(); //membuat objek
}

class _MyHomePageState extends State<MyHomePage> {
  late Map<String, dynamic> transkrip; // Transkrip mahasiswa dari JSON

  @override
  void initState() {
    //inisialisasi
    super.initState();
    // Isi transkrip dari JSON
    String transkripJSON = '''
      {
        "nama": "Freya Enggrayni",
        "NPM": "22082010003",
        "program_studi": "Sistem Informasi",
        "semester": "Genap 2023/2024",
        "mata_kuliah": [
          {
            "kode": "IS01",
            "nama": "Pemrograman Dasar",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "IS03",
            "nama": "Algoritma dan Struktur Data",
            "sks": 3,
            "nilai": "B+"
          },
          {
            "kode": "IS06",
            "nama": "Basis Data",
            "sks": 3,
            "nilai": "A-"
          },
          {
            "kode": "IS05",
            "nama": "Pemrograman Web",
            "sks": 3,
            "nilai": "A"
          },
          {
            "kode": "IS04",
            "nama": "Pengantar Sistem Informasi",
            "sks": 3,
            "nilai": "B"
          }
        ]
      }
    ''';
    transkrip = jsonDecode(transkripJSON);
  }

  double hitungIPK(List<dynamic> mataKuliah) {
    double totalSKS = 0;
    double totalBobot = 0;

    for (var matkul in mataKuliah) {
      int sks = matkul['sks'];
      double bobot = hitungBobot(matkul['nilai']);
      totalSKS += sks;
      totalBobot += sks * bobot;
    }

    return totalBobot / totalSKS;
  } //menghitung ipk berdasarkan daftar mata kuliah

  double hitungBobot(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  } //menghitung berdasarkan nilai transkrip

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HASIL IPK'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Nama'),
            subtitle: Text(transkrip['nama']),
          ),
          ListTile(
            title: Text('NPM'),
            subtitle: Text(transkrip['NPM']),
          ),
          ListTile(
            title: Text('Program Studi'),
            subtitle: Text(transkrip['program_studi']),
          ),
          ListTile(
            title: Text('Semester'),
            subtitle: Text(transkrip['semester']),
          ),
          Divider(),
          Text(
            'Daftar Mata Kuliah:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transkrip['mata_kuliah'].length,
              itemBuilder: (context, index) {
                var matkul = transkrip['mata_kuliah'][index];
                return ListTile(
                  title: Text(matkul['nama']),
                  subtitle:
                      Text('SKS: ${matkul['sks']} | Nilai: ${matkul['nilai']}'),
                );
              },
            ),
          ),
          Divider(),
          Text(
            'IPK ${transkrip['nama']} (${transkrip['NPM']}) adalah:',
          ),
          Text(
            '${hitungIPK(transkrip['mata_kuliah']).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  } //Menampilkan informasi mahasiswa dan daftar mata kuliah beserta nilai dan SKS.
}
