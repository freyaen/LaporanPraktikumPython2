import 'package:flutter/material.dart'; //import
import 'package:http/http.dart' as http; //untuk API
import 'dart:convert'; //convert5 JSON

void main() {
  //UNTUK MEMULAI APLIKASI
  runApp(const MaterialApp(
    title: 'Universities List',
    home: UniversitiesList(),
  ));
}

class UniversitiesList extends StatefulWidget {
  //mendefinisikan widget
  const UniversitiesList({Key? key}) : super(key: key);

  @override
  _UniversitiesListState createState() =>
      _UniversitiesListState(); //mengelola status widget
}

class _UniversitiesListState extends State<UniversitiesList> {
  late Future<List<University>>
      futureUniversities; //Mendeklarasikan variabel futureUniversities untuk menampung hasil pemanggilan API.

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities();
  } //Metode yang dipanggil saat widget diinisialisasi

  Future<List<University>> fetchUniversities() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities =
          data.map((e) => University.fromJson(e)).toList();
      return universities;
    } else {
      throw Exception('Failed to load universities');
    }
  } //Metode untuk melakukan panggilan API dan mengembalikan daftar objek

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities List'),
      ),
      body: Center(
        child: FutureBuilder<List<University>>(
          future: futureUniversities,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].website),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class University {
  final String name;
  final String website;

  University({
    required this.name,
    required this.website,
  }); //constructor

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0],
    );
  } //Metode factory untuk membuat objek University dari data JSON.
}
