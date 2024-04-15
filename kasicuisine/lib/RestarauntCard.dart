// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

import 'FoodCard.dart';

class ResturanutCard extends StatefulWidget {
  ResturanutCard({super.key, this.logo, this.name, this.address});
  String? logo;
  String? name;
  String? address;
  @override
  State<ResturanutCard> createState() => _ResturanutCardState();
}

class _ResturanutCardState extends State<ResturanutCard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SlidingUpPanel(
            padding: const EdgeInsets.all(8),
            //borderRadius: BorderRadius.circular(100),
            isDraggable: true,
            color: Colors.transparent,
            defaultPanelState: PanelState.OPEN,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.8,
            panelBuilder: (sc) {
              return GlassContainer(
                contColor: Colors.white,
                contHeight: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Center(
                      child: Text(
                        "${widget.name}",
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            letterSpacing: 2,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        const Icon(Icons.star_border_outlined),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                          width: 5,
                                        ),
                                itemCount: 5))),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SearchBarAnimation(
                        buttonColour: Colors.black,
                        searchBoxColour: Colors.black,
                        textEditingController: TextEditingController(),
                        isOriginalAnimation: true,
                        enableButtonBorder: true,
                        trailingWidget: const Icon(
                          Icons.restaurant_menu_outlined,
                          color: Colors.white,
                        ),
                        secondaryButtonWidget:
                            const Icon(Icons.cancel_outlined),
                        buttonWidget: const Icon(Icons.search_outlined)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                        child: SingleChildScrollView(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            Text(
                              widget.address!,
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  //letterSpacing: 2,
                                  //fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )
                          ]),
                      scrollDirection: Axis.horizontal,
                    )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Expanded(
                      //height: MediaQuery.of(context).size.height*0.4,
                      child: TitleScrollNavigation(
                        bodyStyle: const NavigationBodyStyle(
                          background: Colors.transparent,
                        ),
                        identiferStyle: NavigationIdentiferStyle(
                            color: Colors.black,
                            width: 8,
                            borderRadius: BorderRadius.circular(50)),
                        barStyle: TitleNavigationBarStyle(
                          activeColor: Colors.black,
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 10),
                          spaceBetween: 40,
                        ),
                        titles: const [
                          "Main Menu",
                        ],
                        pages: [
                          GlassContainer(
                              sigmax: 0,
                              sigmay: 0,
                              shadowColor: Colors.transparent,
                              contColor: Colors.transparent,
                              borderRadiusColor: Colors.transparent,
                              radius: BorderRadius.circular(25),
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("MenuItem/")
                                    .where("Restaurant", isEqualTo: widget.name)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return GridView.count(
                                        childAspectRatio: 0.69,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 25),
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing:
                                            20, //number of columns
                                        children: List.generate(
                                            snapshot.data.docs.length, (index) {
                                          return FutureBuilder(
                                            future: FirebaseStorage.instance
                                                .ref(snapshot.data.docs[index]
                                                    .data()["Image"])
                                                .getDownloadURL(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snap) {
                                              if (snap.hasData) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FoodCard(
                                                                    img: snap.data,
                                                                    restaurant: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Restaurant"] ,
                                                                    name: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Name"],
                                                                    duration: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Duration"],
                                                                    price: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Price"],
                                                                    description: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Description"],
                                                                    rating: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                            .data()["Rating"],
                                                                  )));
                                                    },
                                                    child: GlassContainer(
                                                        contColor:
                                                            Colors.transparent,
                                                        borderRadiusColor:
                                                            Colors.white,
                                                        shadowColor:
                                                            Colors.transparent,
                                                        //contHeight: MediaQuery.of(context).size.height * 0.3,
                                                        radius: BorderRadius
                                                            .circular(25),
                                                        child: FillImageCard(
                                                          heightImage:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.15,
                                                          borderRadius: 25,
                                                          //height: 5,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          imageProvider:
                                                              NetworkImage(
                                                                  snap.data),

                                                          title: Center(
                                                            child: Text(
                                                              "  R${snapshot.data.docs[index].data()["Price"]}  ",
                                                              style: GoogleFonts.lato(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      2),
                                                            ),
                                                          ),

                                                          tags: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                GlassContainer(
                                                                  contColor:
                                                                      Colors
                                                                          .white,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadiusColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .timelapse_outlined,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      Text(
                                                                          "${snapshot.data.docs[index].data()["Duration"]} Min"),
                                                                    ],
                                                                  ),
                                                                ),
                                                                GlassContainer(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .star_border_outlined,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      Text(
                                                                          "${snapshot.data.docs[index].data()["Rating"]}")
                                                                    ],
                                                                  ),
                                                                  contColor:
                                                                      Colors
                                                                          .white,
                                                                  borderRadiusColor:
                                                                      Colors
                                                                          .white,
                                                                  shadowColor:
                                                                      Colors
                                                                          .transparent,
                                                                )
                                                              ],
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                snapshot.data
                                                                    .docs[index]
                                                                    .data()["Name"],
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )));
                                              }
                                              return Container(
                                                height:MediaQuery.of(context).size.height*0.05,
                                                width: MediaQuery.of(context).size.width *0.1,
                                                child: const LoadingIndicator(
                                                  indicatorType:
                                                      Indicator.ballBeat,
                                                  colors: [Colors.black],
                                                  strokeWidth: 1,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  pathBackgroundColor:
                                                      Colors.white,
                                                ));
                                            },
                                          );
                                        }));
                                  }
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: const LoadingIndicator(
                                        indicatorType: Indicator.ballBeat,
                                        colors: [Colors.black],
                                        strokeWidth: 1,
                                        backgroundColor: Colors.transparent,
                                        pathBackgroundColor: Colors.white,
                                      ));
                                },
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            body: GlassContainer(
                contColor: Colors.transparent,
                borderRadiusColor: Colors.transparent,
                child: Align(
                  child: GlassContainer(
                    contColor: Colors.transparent,
                    borderRadiusColor: Colors.transparent,
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref(widget.logo!)
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.25,
                          );
                        } else {}
                        return  Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: const LoadingIndicator(
                              indicatorType: Indicator.ballBeat,
                              colors: [Colors.white],
                              strokeWidth: 1,
                              backgroundColor: Colors.transparent,
                              pathBackgroundColor: Colors.white,
                            ));
                      },
                    ),
                    radius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.topCenter,
                )),
          )),
    );
  }
}
