import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DataPage(),
    PartnerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(65, 130, 69, 100),
        title: Image.asset(
          'images/airguard-logo.png',
          height: 50,
        ),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(65, 130, 69, 100),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Datenausgabe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Unsere Partner',
          ),
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  _launchURL(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Webseite $urlString konnte nicht geladen werden';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30),
          Text(
            'Willkommen zur AirGuard-App!',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Über uns'),
            subtitle: Text('Erfahre mehr über AirGuard und unser Projekt.'),
            onTap: () {
              _launchURL('https://app.recyclingheroes.at/about');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Kontaktiere uns'),
            subtitle:
                Text('Bei Fragen oder Feedback stehen wir zur Verfügung.'),
            onTap: () {
              _launchURL('mailto:info@airguard-app.com');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final List<Map<String, dynamic>> _allSchools = [
    {"id": 1, "name": "TGM", "address": "Wexstraße 17-19"},
    {"id": 2, "name": "Schule2", "address": "Adresse2"},
    {"id": 3, "name": "Schule3", "address": "Adresse3"},
    {"id": 4, "name": "Schule4", "address": "Adresse4"},
    {"id": 5, "name": "Schule5", "address": "Adresse5"},
    {"id": 6, "name": "Schule6", "address": "Adresse6"},
  ];

  List<Map<String, dynamic>> _foundSchools = [];
  @override
  initState() {
    _foundSchools = _allSchools;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // Wenn das Suchfeld leer ist, zeige alle Schulen an
      setState(() {
        _foundSchools = _allSchools;
      });
    } else {
      // Filtere die Schulen nach dem eingegebenen Schlüsselwort
      setState(() {
        _foundSchools = _allSchools
            .where((school) => school["name"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _foundSchools.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundSchools.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundSchools[index]["id"]),
                      color: Color.fromRGBO(150, 150, 150, 100),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Text(
                          _foundSchools[index]["id"].toString(),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        title: Text(_foundSchools[index]['name'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            '${_foundSchools[index]["address"].toString()}',
                            style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {
                            // Speichern der ausgewählten ID
                            int selectedId = _foundSchools[index]["id"];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(selectedId: selectedId),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int selectedId;

  DetailPage({required this.selectedId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> sensorData = {}; // Hier werden die Daten gespeichert

  @override
  void initState() {
    super.initState();
    fetchData(widget.selectedId); // Daten laden, wenn die Seite erstellt wird
  }

  Future<void> fetchData(int id) async {
    try {
      var url = Uri.parse('https://app.recyclingheroes.at:5000/getData');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Controller_ID': id.toString()}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          sensorData = data;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(65, 130, 69, 100),
        title: Image.asset(
          'images/airguard-logo.png',
          height: 50,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 100)),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      sensorData.isNotEmpty
                          ? "Temperatur: ${sensorData['Temperature']}°C"
                          : 'No data available',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      sensorData.isNotEmpty
                          ? "Luftfeuchtigkeit: ${sensorData['Humidity']}g/m^3"
                          : 'No data available',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      sensorData.isNotEmpty
                          ? "CO2: ${sensorData['CO2']}ppm"
                          : 'No data available',
                      style: const TextStyle(fontSize: 20),
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

class PartnerPage extends StatelessWidget {
  goToWebPage(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Webseite $urlString konnte nicht geladen werden';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              'Unsere Partner',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/TGM_Logo.png',
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://www.tgm.ac.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/BMBWF_Logo_srgb.png',
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://www.bmbwf.gv.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/TU-Logo-Austria_CMYK.png',
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://www.tuwien.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/OeAD_LogoUnterzeile_DE_RGB.png',
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://oead.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
          ],
        ),
      ),
    );
  }
}
