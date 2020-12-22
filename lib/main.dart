import 'package:cinema_mobile_app/menuItem.dart';
import 'package:cinema_mobile_app/setting-page.dart';
import 'package:cinema_mobile_app/villes-page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.blueGrey),
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> listVilles;

  final menus = [
    {'title': 'Home', 'icon': Icon(Icons.home), 'page': VillePage()},
    {'title': 'Setting', 'icon': Icon(Icons.settings), 'page': SettingPage()},
    {
      'title': 'Contact',
      'icon': Icon(Icons.contact_mail),
      'page': SettingPage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema Page "),
      ),
      body: Center(
        child: Text("Home Page"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("./images/profile.png"),
                    radius: 50.0,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.6, 0.9],
                      colors: [Colors.grey, Colors.blueGrey, Colors.black]),
                )),
            ...this.menus.map((item) {
              return Column(
                children: <Widget>[
                  Divider(color: Colors.blueGrey),
                  MenuItem(item['title'], item['icon'], (context) {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => item['page']));
                  })
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
