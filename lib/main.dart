import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';


void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  AwesomeNotifications().initialize(
  null,
  [
    NotificationChannel(
      channelKey: "basicchannel", // Ändere den Kanalschlüssel hier entsprechend
      channelName: "channelname",
      channelDescription: "description"
    )
  ],
  debug: true
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Benutzername',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();

                // Erstelle ein Map-Objekt mit den Anmeldeinformationen
                Map<String, String> credentials = {
                  'username': username,
                  'password': password,
                };

                try {
                  // Sende den POST-Request an die angegebene URL
                  http.Response response = await http.post(
                    Uri.parse('https://airguard.recyclingheroes.at:5000/login'),
                    body: credentials,
                  );

                  // Überprüfe, ob die Anmeldung erfolgreich war (zum Beispiel anhand des Statuscodes)
                  if (response.statusCode == 200) {
                    // Konvertiere die Antwort in JSON
                    Map<String, dynamic> data = json.decode(response.body);

                    // Extrahiere die ID aus der Antwort
                    int userId = data['Controller_ID'][0];

                    // Navigiere zur MainPage und übergebe die ID
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(userId: userId),
                      ),
                    );
                  } else {
                    // Anzeige einer Fehlermeldung oder anderen Aktion bei fehlgeschlagenem Login
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ungültige Anmeldeinformationen'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (error) {
                  print('Error: $error');
                  // Handle den Fehler entsprechend
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(65, 130, 69, 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final int userId;

  MainPage({required this.userId});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    _pages = [
    DetailPage(selectedId: widget.userId),
    HomePage(),
    PartnerPage(),
    ];
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Datenausgabe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'About Us',
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

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Über uns',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'AirGuard ermöglicht Schulen die Darstellung von Luftqualitätsdaten. '
              'Wir bieten eine benutzerfreundliche Plattform, um Schülern und Lehrern '
              'Zugang zu wichtigen Umweltdaten zu ermöglichen.',
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Team',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            _buildTeamSection(),
            Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Kontaktiere uns'),
              subtitle: const Text(
                  'Bei Fragen oder Feedback stehen wir zur Verfügung.'),
              onTap: () {
                _launchURL('mailto:info@airguard-app.com');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      children: [
        _buildTeamMember(
          image: 'images/trisser.png',
          description: 'Timo Risser - Projektleiter',
        ),
        _buildTeamMember(
          image: 'images/llatschbacher.png',
          description: 'Lukas Latschbacher - Backend Developer',
        ),
        _buildTeamMember(
          image: 'images/jertl.png',
          description: 'Jakob Ertl - Arduino Designer und Developer',
        ),
        _buildTeamMember(
          image: 'images/adragschnigg.png',
          description: 'Andreas Dragaschnigg - Web developer',
        ),
        _buildTeamMember(
          image: 'images/AleksaMarinkovic.jpg',
          description: 'Aleksa Marinkovic - App developer',
        ),
        // Füge weitere Teammitglieder hier hinzu
      ],
    );
  }

  Widget _buildTeamMember(
      {required String image, required String description}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(height: 10),
          Text(description),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int selectedId;

  const DetailPage({required this.selectedId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> sensorData = {}; // Hier werden die Daten gespeichert
  late Timer _timer;
  late Timer _timer2;
  bool isPopupOpen = false; // Variable, um den Popup-Zustand zu verfolgen

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
        if(!isAllowed){
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
    });
    fetchData(widget.selectedId);
     // Daten laden, wenn die Seite erstellt wird
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      fetchData(widget.selectedId); // Alle 1 Sekunde neue Daten laden
    });
    _timer2 = Timer.periodic(const Duration(seconds: 900), (Timer t) {
      if ((sensorData["CO2"] ?? 0) > 1399) {
        triggerNotification();
      }
    });
    super.initState();  
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Timer bei Widget-Entfernung stoppen, um Speicherlecks zu vermeiden
    super.dispose();
  }

  Future<void> fetchData(int id) async {
    try {
      var url = Uri.parse('https://airguard.recyclingheroes.at:5000/getData');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"Controller_ID": id.toString()}),
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

  Color getColorForCO2(int co2Value) {
    if (co2Value >= 0 && co2Value <= 999) {
      return Colors.green;
    } else if (co2Value >= 1000 && co2Value <= 1399) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  void showVentilationPopup() {
    if (isPopupOpen) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        isPopupOpen = true;
        return AlertDialog(
          title: Text('Lüften empfohlen'),
          content: Text('Lüften Sie den Raum, um die Luftqualität zu verbessern.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isPopupOpen = false;
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  triggerNotification(){
    AwesomeNotifications().createNotification(content: NotificationContent(id:10,channelKey: "basicchannel",title: "Lüften empfohlen",body: "Die CO2-Werte sind über 1400 ppm gestiegen. Lüften Sie den Raum, um die Luftqualität zu verbessern."));
  }
  

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.thermostat, size: 40, color: Colors.black),
                      const SizedBox(height: 10),
                      Text(
                        sensorData.isNotEmpty
                            ? "Temperatur: ${sensorData["Temperature"]} °C"
                            : 'No data available',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.cloud, size: 40, color: getColorForCO2(sensorData["CO2"] ?? 0)),
                      const SizedBox(height: 10),
                      Text(
                        sensorData.isNotEmpty
                            ? "CO2: ${sensorData["CO2"]} ppm"
                            : 'No data available',
                            
                        style: TextStyle(
                          fontSize: 20,
                          color: getColorForCO2(sensorData["CO2"] ?? 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.water_damage, size: 40, color: Colors.black),
                      const SizedBox(height: 10),
                      Text(
                        sensorData.isNotEmpty
                            ? "Luftfeuchtigkeit: ${sensorData["Humidity"]} %"
                            : 'No data available',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
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
  const PartnerPage({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Unsere Partner',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Container(
              width: 200,
              height: 200,
              child: Image.asset('images/TGM_Logo.png'),
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://www.tgm.ac.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              icon: Container(
              width: 200,
              height: 200,
              child: Image.asset('images/BMBWF_Logo_srgb.png'),
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://www.bmbwf.gv.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              icon: Container(
              width: 200,
              height: 200,
              child: Image.asset('images/TU-Logo-Austria_CMYK.png'),
            ),
              
              onPressed: () async {
                await goToWebPage(
                    'https://www.tuwien.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              icon: Container(
              width: 200,
              height: 200,
              child: Image.asset('images/OeAD_LogoUnterzeile_DE_RGB.png'),
              ),
              onPressed: () async {
                await goToWebPage(
                    'https://oead.at'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
            Divider(),
            IconButton(
              icon: Container(
              width: 200,
              height: 200,
              child: Image.asset('images/beeproducedTransparent.png'),
              ),
              
              onPressed: () async {
                await goToWebPage(
                    'https://www.beeproduced.com/de'); // Hier fügst du den Link zur Webseite hinzu
              },
            ),
          ],
        ),
      ),
    );
  }
}