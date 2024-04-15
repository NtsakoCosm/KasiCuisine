import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'Category.dart';

class DiscoverTypes extends StatefulWidget {
  DiscoverTypes({super.key});

  @override
  State<DiscoverTypes> createState() => _DiscoverTypesState();
}

class _DiscoverTypesState extends State<DiscoverTypes>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int screenindex = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<Tab> sorttabs = const [
      Tab(
        text: "Popular",
      ),
      Tab(
        text: "Time Period",
      ),
      Tab(
        text: "Cuisine",
      ),
      Tab(
        text: "Resturants",
      )
    ];
    List<Widget> categories = [
    Column(
            children: [
              SearchBarAnimation(
                  textEditingController: TextEditingController(),
                  isOriginalAnimation: true,
                  onChanged: (v) {},
                  searchBoxColour: Colors.black,
                  trailingWidget:
                      const Icon(Icons.search_outlined, color: Colors.white),
                  secondaryButtonWidget:
                      const Icon(Icons.menu_outlined, color: Colors.black),
                  buttonWidget:
                      const Icon(Icons.search_outlined, color: Colors.black)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GlassContainer(
                contColor: Colors.transparent,
                shadowColor: Colors.transparent,
                borderRadiusColor: Colors.transparent,
                sigmax: 0,
                sigmay: 0,
                //contHeight: height * 0.6,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("Palettes")
                      .where("Type", isEqualTo: "Popular")
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.count(
                          controller: ScrollController(),
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          children:
                              List.generate(snapshot.data.docs.length, (index) {
                            return FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref(
                                      snapshot.data.docs[index].data()["Image"])
                                  .getDownloadURL(),
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                if (snap.hasData) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CatagoryScreen(
                                                        name: snapshot.data
                                                                .docs[index]
                                                            ["Name"],
                                                        img: snap.data)));
                                      },
                                      child: TransparentImageCard(
                                        endColor: Colors.transparent,
                                        width: width * 0.5,
                                        height: height * 0.25,
                                        imageProvider: NetworkImage(snap.data),
                                        title: GlassContainer(
                                          contColor: Colors.white,
                                          child: Text(
                                            "  ${snapshot.data.docs[index].data()["Name"]}  ",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ));
                                }
                                return const LoadingIndicator(
                                    indicatorType: Indicator.ballBeat);
                              },
                            );
                          }));
                    }
                    return const LoadingIndicator(
                        indicatorType: Indicator.ballBeat);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
    Column(
            children: [
              SearchBarAnimation(
                  textEditingController: TextEditingController(),
                  isOriginalAnimation: true,
                  onChanged: (v) {},
                  searchBoxColour: Colors.black,
                  trailingWidget:
                      const Icon(Icons.search_outlined, color: Colors.white),
                  secondaryButtonWidget:
                      const Icon(Icons.menu_outlined, color: Colors.black),
                  buttonWidget:
                      const Icon(Icons.search_outlined, color: Colors.black)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GlassContainer(
                contColor: Colors.transparent,
                shadowColor: Colors.transparent,
                borderRadiusColor: Colors.transparent,
                sigmax: 0,
                sigmay: 0,
                //contHeight: height * 0.6,
                child: GridView.count(
                    controller: ScrollController(),
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.4,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    children: List.generate(3, (index) {
                      var timeimages = [
                        "assets/bf.jpg",
                        "assets/lunch.jpg",
                        "assets/dinner.jpg",
                      ];
                      var titles = [
                        "Breakfast",
                        "Lunch",
                        "Dinner",
                      ];
                      return TransparentImageCard(
                        endColor: Colors.transparent,
                        width: width,
                        height: height * 0.25,
                        imageProvider: AssetImage(timeimages[index]),
                        title: GlassContainer(
                          contColor: Colors.white,
                          child: Text(
                            "  ${titles[index]}  ",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        ),
                      );
                    })),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),       
    Column(
        children: [
          SearchBarAnimation(
              textEditingController: TextEditingController(),
              isOriginalAnimation: true,
              onChanged: (v) {},
              searchBoxColour: Colors.black,
              trailingWidget:
                  const Icon(Icons.search_outlined, color: Colors.white),
              secondaryButtonWidget:
                  const Icon(Icons.menu_outlined, color: Colors.black),
              buttonWidget:
                  const Icon(Icons.search_outlined, color: Colors.black)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          GlassContainer(
            contColor: Colors.transparent,
            shadowColor: Colors.transparent,
            borderRadiusColor: Colors.transparent,
            sigmax: 0,
            sigmay: 0,
            //contHeight: height * 0.6,
            child: GridView.count(
                controller: ScrollController(),
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                children: List.generate(4, (index) {
                  var timeimages = [
                    "assets/traditional.jpg",
                    "assets/italian.jpg",
                    "assets/indian.jpg",
                    "assets/chinese.jpg"
                  ];
                  var titles = ["Kasi", "Italian", "Indian", "Chinese"];
                  return TransparentImageCard(
                    endColor: Colors.transparent,
                    width: width * 0.5,
                    height: height * 0.25,
                    imageProvider: AssetImage(timeimages[index]),
                    title: GlassContainer(
                      contColor: Colors.white,
                      child: Text(
                        "  ${titles[index]}  ",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ),
                  );
                })),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    Column(
            children: [
              SearchBarAnimation(
                  textEditingController: TextEditingController(),
                  isOriginalAnimation: true,
                  onChanged: (v) {},
                  searchBoxColour: Colors.black,
                  trailingWidget:
                      const Icon(Icons.search_outlined, color: Colors.white),
                  secondaryButtonWidget:
                      const Icon(Icons.menu_outlined, color: Colors.black),
                  buttonWidget:
                      const Icon(Icons.search_outlined, color: Colors.black)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              GlassContainer(
                contColor: Colors.transparent,
                shadowColor: Colors.transparent,
                borderRadiusColor: Colors.transparent,
                sigmax: 0,
                sigmay: 0,
                //contHeight: height * 0.6,
                child: GridView.count(
                    controller: ScrollController(),
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    childAspectRatio: 1.2,
                    children: List.generate(7, (index) {
                      var timeimages = [
                        "assets/bf.jpg",
                        "assets/lunch.jpg",
                        "assets/dinner.jpg",
                        "assets/traditional.jpg",
                        "assets/italian.jpg",
                        "assets/indian.jpg",
                        "assets/chinese.jpg"
                      ];
                      var titles = [
                        "Breakfast",
                        "Lunch",
                        "Dinner",
                        "Kasi",
                        "Italian",
                        "Indian",
                        "Chinese"
                      ];
                      return TransparentImageCard(
                        endColor: Colors.transparent,
                        width: width,
                        height: height * 0.25,
                        imageProvider: AssetImage(timeimages[index]),
                        title: GlassContainer(
                          contColor: Colors.white,
                          child: Text(
                            "  ${titles[index]}  ",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        ),
                      );
                    })),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          )
    ];
    var tabcount = categories.length;
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
                    'assets/discover.jpg',
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
                    text: 'Discover Palettes ',
                    collapsedStyle: GoogleFonts.lato(
                        fontWeight: FontWeight.w300, color: Colors.black),
                    expandedStyle: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
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
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  DefaultTabController(
                    length: tabcount,
                    initialIndex: 0,
                    child: TabBar(
                      onTap: (i) {
                        setState(() {
                          screenindex = i;
                        });
                      },
                      enableFeedback: true,
                      isScrollable: true,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: Colors.white,
                      tabs: sorttabs,
                      labelColor: Colors.white,
                      // add it here
                      indicator: DotIndicator(
                        color: Colors.white,
                        distanceFromCenter: 16,
                        radius: 3,
                        paintingStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                ],
              );
            }, childCount: 1)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return IndexedStack(index: screenindex, children: categories);
            }, childCount: 1))
          ],
        )
      ],
    );
  }
}
