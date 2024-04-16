import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/pages/import_data_page.dart';
import 'package:vitals/pages/show_vitalsigns_page.dart';
import 'package:vitals/pages/vital_signs_graphs_page.dart';
import 'package:vitals/providers/imported_files_provider.dart';
import 'pages/add_measurements_page.dart';
import 'pages/database_metrics_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ImportedFilesProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vitals App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AddMeasurementsPage(),
    ShowVitalSignsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Add Measurement' : 'Show Measurements'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Add Measurement'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              title: Text('Show Measurements'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ), ListTile(
              title: Text('Charts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => VitalSignsGraphsPage()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Database Metrics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DatabaseMetricsPage()));
              },
            ),
            ListTile(
              title: Text('Import Data'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImportDataPage()));
              },
            ),

          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
