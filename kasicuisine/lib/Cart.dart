import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:stepo/stepo.dart';

class FoodCart extends StatefulWidget {
  FoodCart({super.key});

  @override
  State<FoodCart> createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  var tabindex = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.asset(
          "assets/wall.jpg",
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: FlexibleHeaderDelegate(
                statusBarHeight: MediaQuery.of(context).padding.top,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                background: MutableBackground(
                  expandedWidget: Image.asset(
                    'assets/cart3.jpg',
                    fit: BoxFit.cover,
                  ),
                  collapsedColor: Colors.white,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
                children: [
                  FlexibleTextItem(
                    text: 'Shopping Cart',
                    collapsedStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.w300, color: Colors.black),
                    expandedStyle: GoogleFonts.lato(
                        fontSize: 33,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                    expandedAlignment: Alignment.bottomLeft,
                    collapsedAlignment: Alignment.center,
                    expandedPadding: EdgeInsets.all(1),
                  ),
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var user = FirebaseAuth.instance.currentUser?.uid;
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("Cart")
                      .where("uid", isEqualTo: user)
                      .get()
                      ,
                  builder: (BuildContext context, AsyncSnapshot ss) {
                    if (ss.hasData) {
                      List restaurants = [];
                      List<dynamic> res = ss.data.docs[0].data()["Restaurant"];
                      restaurants = res;
                      var len = res.length;

                      var listviews = List.generate(len, (v) {
                        double total = 0;
                        var items = List.from(
                            ss.data.docs[0].data()["MenuItems"][res[v]]);

                        items.forEach(((element) => total += element["Price"]));
                        var itemlen = items.length;
                        return GlassContainer(
                            contColor: Colors.transparent,
                            sigmax: 0,
                            sigmay: 0,
                            shadowColor: Colors.transparent,
                            borderRadiusColor: Colors.transparent,
                            child: Column(children: [
                              ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  controller: ScrollController(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                        key: GlobalKey(),
                                        onDismissed: ((direction) async {
                                          setState(() {
                                            itemlen -= 1;
                                          });

                                          var cart = await FirebaseFirestore
                                              .instance
                                              .collection("Cart")
                                              .doc(ss.data.docs[0].id)
                                              .set({
                                            "MenuItems": {
                                              res[v]: FieldValue.arrayRemove([
                                                {
                                                  "Name": ss.data.docs[0]
                                                          .data()["MenuItems"]
                                                      [res[v]][index]["Name"],
                                                  "Price": ss.data.docs[0]
                                                          .data()["MenuItems"]
                                                      [res[v]][index]["Price"],
                                                  "Image": ss.data.docs[0]
                                                          .data()["MenuItems"]
                                                      [res[v]][index]["Image"]
                                                }
                                              ])
                                            }
                                          }, SetOptions(merge: true));
                                          var wholecart = FirebaseFirestore
                                              .instance
                                              .collection("Cart")
                                              .doc(ss.data.docs[0].id);
                                          var cartcheck = await wholecart.get();
                                          List menuitems = List.from(cartcheck
                                              .data()!["MenuItems"][res[v]]);

                                          if (menuitems.isEmpty) {
                                            await wholecart.set({
                                              "Restaurant":
                                                  FieldValue.arrayRemove(
                                                      [res[v]])
                                            }, SetOptions(merge: true));

                                            await wholecart.set({
                                              "MenuItems": {
                                                res[v]: FieldValue.delete()
                                              }
                                            }, SetOptions(merge: true));
                                            setState(() {
                                              restaurants.remove(res[v]);
                                              len -= 1;
                                              if (tabindex > 0 && restaurants.isNotEmpty) {
                                                tabindex -= 1;
                                              } else if(tabindex ==0 && restaurants.isEmpty)  {
                                                tabindex = -1;
                                              }
                                            });
                                          }
                                        }),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.025,
                                            ),
                                            GlassContainer(
                                              contHeight: height * 0.1,
                                              sigmax: 0,
                                              sigmay: 0,
                                              shadowColor: Colors.transparent,
                                              contColor: Colors.transparent,
                                              radius: const BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  // bottomRight: Radius.circular(25),
                                                  topLeft: Radius.circular(25)),
                                              borderRadiusColor: Colors.white54,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.25,
                                                    height: height * 0.1,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        25),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        2)),
                                                        child: Image.network(
                                                          ss.data.docs[0].data()[
                                                                      "MenuItems"]
                                                                  [res[v]]
                                                              [index]["Image"],
                                                          width: width * 0.25,
                                                          height: height * 0.1,
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Container(
                                                    width: width * 0.3,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${ss.data.docs[0].data()["MenuItems"][res[v]][index]["Name"]}",
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          letterSpacing: 1.5,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  Container(
                                                    width: width * 0.15,
                                                    child: Text(
                                                      "R${ss.data.docs[0].data()["MenuItems"][res[v]][index]["Price"]}",
                                                      style: GoogleFonts.lato(
                                                          letterSpacing: 2,
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  //SizedBox(width: width * 0.01),
                                                  SizedBox(width: width * 0.02),
                                                  Stepo(
                                                    key: UniqueKey(),
                                                    initialCounter: 1,
                                                    width: width * 0.2,
                                                    iconColor: Colors.white,
                                                    textColor: Colors.white,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.025,
                                            )
                                          ],
                                        ));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                  itemCount: itemlen),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        )),
                                    child: Column(children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      Text("Check-Out",
                                          style:
                                              GoogleFonts.lato(fontSize: 18)),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Total:",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("${total}")
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Resturant:",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Text("${res[v]}"),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Destination:",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          const Text(
                                              "6620,dendu,Street,Nellmapius")
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        child: Text("Complete Payment",
                                            style: GoogleFonts.lato()),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                    ])),
                              )
                            ]));
                      });
                      return Column(
                        children: [
                          tabindex != -1
                              ? DefaultTabController(
                                  length: res.length,
                                  initialIndex: tabindex,
                                  child: TabBar(
                                    onTap: (i) {
                                      setState(() {
                                        tabindex = i;
                                      });
                                    },
                                    enableFeedback: true,
                                    isScrollable: true,
                                    unselectedLabelColor: Colors.black,
                                    indicatorColor: Colors.white,
                                    tabs: List.generate(
                                        res.length,
                                        (ii) => Tab(
                                              text: res[ii],
                                            )),
                                    labelColor: Colors.white,
                                    // add it here
                                    indicator: DotIndicator(
                                      color: Colors.white,
                                      distanceFromCenter: 16,
                                      radius: 3,
                                      paintingStyle: PaintingStyle.fill,
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text("Empty Cart"),
                                ),
                          tabindex != -1
                              ? listviews[tabindex]
                              : Container(
                                  child: Text(" "),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      );
                    }
                    return LoadingIndicator(indicatorType: Indicator.ballBeat);
                  },
                );
              },
              childCount: 1,
            )),
          ],
        ),
      ],
    );
  }
}

class CartTotals extends StatefulWidget {
  const CartTotals({super.key});

  @override
  State<CartTotals> createState() => _CartTotalsState();
}

class _CartTotalsState extends State<CartTotals> {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        contColor: Colors.white,
        radius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: Column(
          children: [],
        ));
  }
}
