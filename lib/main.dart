import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Inhalt der HomePage'),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage()),
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

class DetailPage extends StatelessWidget {
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
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(child: Text('Outlined Card')),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(child: Text('Outlined Card')),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 100,
                  child: Center(child: Text('Outlined Card')),
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
