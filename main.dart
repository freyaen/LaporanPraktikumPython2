import 'package:flutter/material.dart'; //import
import 'package:http/http.dart' as http;
import 'dart:convert'; // untuk convert json

void main() {
  runApp(const MyApp()); //mulai aplikasi
}

// menampung data hasil pemanggilan API
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  } //Metode factory untuk membuat objek Activity dari data JSON.
}

class MyApp extends StatefulWidget {
  //mendefinisikan widget
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  } //membuat objek untuk mengelola status widget
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; //menampung hasil

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  Future<Activity> init() async {
    //inisialisasi
    return Activity(aktivitas: "", jenis: "");
  }

  //fetch data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init();
  } //Metode yang dipanggil saat widget diinisialisasi.

  @override
  Widget build(Object context) {
    //Membuat widget
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // default: loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  } //untuk membangun widget UI
}
