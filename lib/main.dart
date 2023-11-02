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
          'images/airguard-logo.png', // Passe den Pfad entsprechend an
          height: 50, // Passe die Höhe an
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
  String? selectedOption = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? value) {
                setState(() {
                  selectedOption = value;
                });
              },
              items: <String>[
                'Option 1',
                'Option 2',
                'Option 3',
                'Option 4',
                'Option 5',
                'Option 6',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(padding: EdgeInsets.only(top: 60)),
            const Card(
              color: Color.fromRGBO(225, 225, 225, 100),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 270,
                height: 100,
                child: Center(
                    child: Text(
                  "Temp:",
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            const Card(
              color: Color.fromRGBO(225, 225, 225, 100),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 270,
                height: 100,
                child: Center(
                    child: Text("Luftfeuchte:", style: TextStyle(fontSize: 20))),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            const Card(
              color: Color.fromRGBO(225, 225, 225, 100),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 270,
                height: 100,
                child: Center(
                    child: Text(
                  "CO2:",
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerPage extends StatelessWidget {
  goToWebPage(String urlString) async {
   if(await canLaunch(urlString)){
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
              'About Us',
              style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              iconSize: 100,
              icon: Image.asset(
                'images/trisser.jpg',
              ),
              onPressed: () async {
                await goToWebPage('https://pornhub.com'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/adragaschnig.jpg',
                
              ),
              onPressed: () async {
                await goToWebPage('https://pornhub.com'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/jertl.jpg',
              ),
              onPressed: () async{
                await goToWebPage('https://www.tuwien.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/llatschbacher.jpg',
              ),
              onPressed: () async {
                await goToWebPage('https://oead.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/amarinkovic.jpg',
              ),
              onPressed: () async {
                await goToWebPage('https://oead.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/TGM_Logo.png',
              ),
              onPressed: () async {
                await goToWebPage('https://www.tgm.ac.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/BMBWF_Logo_srgb.png',
                
              ),
              onPressed: () async {
                await goToWebPage('https://www.bmbwf.gv.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/TU-Logo-Austria_CMYK.png',
              ),
              onPressed: () async{
                await goToWebPage('https://www.tuwien.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              iconSize: 150,
              icon: Image.asset(
                'images/OeAD_LogoUnterzeile_DE_RGB.png',
              ),
              onPressed: () async {
                await goToWebPage('https://oead.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
          ],
        ),
      ),
    );
  }
}

