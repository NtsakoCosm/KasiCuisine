// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stepo/stepo.dart';
import 'package:loading_indicator/loading_indicator.dart';

class FoodCard extends StatefulWidget {
  FoodCard(
      {super.key,
      this.name,
      this.restaurant,
      this.img,
      this.duration,
      this.description,
      this.price,
      this.rating});

  String? name;
  String? restaurant;
  String? img;
  num? duration;
  String? description;
  num? price;
  num? rating;
  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  var added = "Add to Cart";
  var qty = 1;
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!.uid;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SlidingUpPanel(
              isDraggable: false,
              color: Colors.transparent,
              defaultPanelState: PanelState.OPEN,
              maxHeight: MediaQuery.of(context).size.height * 0.75,
              minHeight: MediaQuery.of(context).size.height * 0.75,
              panelBuilder: (sc) {
                return SlidingUpPanel(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  isDraggable: true,
                  color: Colors.transparent,
                  defaultPanelState: PanelState.CLOSED,
                  maxHeight: MediaQuery.of(context).size.height * 0.15,
                  minHeight: MediaQuery.of(context).size.height * 0.15,
                  panelBuilder: (sc) {
                    return GlassContainer(
                      shadowColor: Colors.transparent,
                      borderRadiusColor: Colors.white,
                      sigmax: 0,
                      sigmay: 0,
                      radius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      contColor: Colors.white,
                      child: Column(
                        children: [
                          Stepo(
                            initialCounter: 1,
                            onIncrementClicked: (v) {
                              setState(() {
                                qty = v;
                              });
                            },
                            onDecrementClicked: (v) {
                              setState(() {
                                qty = v;
                              });
                            },
                            key: UniqueKey(),
                            width: MediaQuery.of(context).size.width * 0.3,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            iconColor: Colors.black,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: ()async {
                                
                                  var cart = await FirebaseFirestore.instance
                                      .collection("Cart")
                                      .where("uid", isEqualTo: user)
                                      .get();
                                  List restaurants =
                                      cart.docs[0].data()["Restaurant"];

                                  if (restaurants.contains(widget.restaurant)) {
                                    FirebaseFirestore.instance
                                        .collection("Cart")
                                        .doc(cart.docs[0].id)
                                        .set({
                                      "MenuItems": {
                                        widget.restaurant:
                                            FieldValue.arrayUnion([
                                          {
                                            "Name": widget.name,
                                            "Price": widget.price,
                                            "Image": widget.img
                                          }
                                        ])
                                      }
                                    }, SetOptions(merge: true));
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection("Cart")
                                        .doc(cart.docs[0].id)
                                        .set({
                                      "Restaurant": FieldValue.arrayUnion([widget.restaurant])
                                    }, SetOptions(merge: true));
                                    FirebaseFirestore.instance
                                        .collection("Cart")
                                        .doc(cart.docs[0].id)
                                        .set({
                                      "MenuItems": {widget.restaurant:
                                            FieldValue.arrayUnion([{
                                      "Name":widget.name,
                                      "Price":widget.price,
                                      "Image":widget.img
                                      }])
                                      }
                                    }, SetOptions(merge: true));
                                  }
                                  setState(() {
                                  var added = "Added";
                                });
                              },
                              child: Text("  ${added}   ",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 3))),
                        ],
                      ),
                    );
                  },
                  body: GlassContainer(
                    radius: BorderRadius.circular(25),
                    contColor: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Center(
                            child: Text("${widget.restaurant}-${widget.name}",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: 3))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text("${widget.duration} Min.",
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 3))
                                ],
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star_border_outlined),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text("${widget.rating}",
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 3))
                                ],
                              ),
                            ])),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: GlassContainer(
                            shadowColor: Colors.transparent,
                            contColor: Colors.transparent,
                            child: Text("  R${widget.price}  ",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: 3)),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        GlassContainer(
                            contColor: Colors.white,
                            shadowSpreadRadius: 0,
                            shadowColor: Colors.transparent,
                            borderRadiusColor: Colors.transparent,
                            child: Text("${widget.description}",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: 2))),
                      ],
                    ),
                  ),
                );
              },
              body: Align(
                child: GlassContainer(
                  contColor: Colors.transparent,
                  borderRadiusColor: Colors.transparent,
                  child: Image.network(
                    "${widget.img}",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  radius: BorderRadius.circular(30),
                ),
                alignment: Alignment.topCenter,
              )),
        ));

    ;
  }
}
