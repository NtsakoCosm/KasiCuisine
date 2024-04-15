import 'package:curved_drawer_fork/curved_drawer_fork.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurantui/Home.dart';
import 'package:restaurantui/Menu.dart';
import 'package:restaurantui/Orders.dart';
import 'package:restaurantui/Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasi Cuisine DashBoard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Kasi Cuisine DashBoard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _index = 0;

 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    drawer: CurvedDrawer(
    color: Colors.white,
    labelColor: Colors.black,
    backgroundColor: Colors.transparent,
    width: 75.0,
    items: const <DrawerItem>[
      DrawerItem(icon: Icon(Icons.home_filled),label: "Home"),
      DrawerItem(icon: Icon(Icons.restaurant_menu_outlined), label: "Menu"),
      DrawerItem(icon: Icon(Icons.payment_outlined), label: "Orders"),
      DrawerItem(icon: Icon(Icons.online_prediction_rounded), label: "Current Orders"),
      DrawerItem(icon: Icon(Icons.payments_sharp), label: "Finished Orders"),
      DrawerItem(icon: Icon(Icons.rate_review_outlined), label: "Customer Feedback"),
      DrawerItem(icon: Icon(Icons.speaker_group_outlined),label: "Marketing/Promoting"),
      DrawerItem(icon: Icon(Icons.settings),label: "Settings"),
    ],
    onTap: (index) {
      setState(() {
     _index = index;
      
    });
      
    },
  ),
      appBar: AppBar(
        title: Center(child:Text(
          "",
          style:GoogleFonts.lato(
            color:Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 26,
            letterSpacing: 2,
            wordSpacing: 2

        )),
          ),
      ),
      body:  [
          Menu(),
          Menu(),
          Orders(),
          Settings(),
          HomeScreen(),
          Menu(),
          Orders(),
          Settings()
        ][_index],
        
      
    );
  }
}
