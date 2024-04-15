import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasicuisine/main.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var email;
    var password;
    Future<void> signInWithEmailAndPassword(
        String email, String password) async {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }

    //var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/wall.jpg",
              fit: BoxFit.fill,
              width: width,
              height: height,
            ),
            Center(
              child: GlassContainer(
                contHeight: height * 0.5,
                contWidth: width,
                sigmax: 0,
                sigmay: 0,
                child: Column(
                  children: [
                    Text(
                      "Sign In",
                      style: GoogleFonts.lato(color: Colors.black),
                    ),
                    TextField(
                      controller: TextEditingController(text: "Email"),
                      onChanged: (v) {
                        setState(() {
                          email = v;
                        });
                      },
                    ),
                    TextField(
                      controller: TextEditingController(text: "Email"),
                      onChanged: (v) {
                        setState(() {
                          password = v;
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          signInWithEmailAndPassword("Microdarkcosm@outlook.com", "kkkccc");
                          Navigator.pushNamed(context, '/explore');
                          
                        },
                        child: Text("log in"))
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
