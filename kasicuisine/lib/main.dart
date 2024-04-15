// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, must_be_immutable
import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:glass_container/glass_container.dart';
import 'package:kasicuisine/FoodCard.dart';
import 'package:kasicuisine/Login.dart';
import 'package:kasicuisine/LoginScreen.dart';
import 'package:kasicuisine/ResturantScreen.dart';
import 'package:kasicuisine/T.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_wall_layout/flutter_wall_layout.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:image_card/image_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'Cart.dart';
import 'Discover.dart';

import 'RestarauntCard.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'Settings.dart';
import 'TrackOrder.dart';
import 'LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => Log());
            case '/explore':
              return MaterialPageRoute(builder: (context) => ExplorePage());
          }
        },
      ),
    ),
      );
  
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  PanelController panelc = PanelController();
  var _selectedIndex = 0;
  var navbarcolor = Colors.black;
  bool isdrag = true;

  List<Widget> pageindex = [
    PanelBody(key: UniqueKey()),
    DiscoverTypes(key: UniqueKey()),
    Container(),
    OrderTracker(key: UniqueKey()),
    UserSettings(key: UniqueKey()),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kasi Cuisine',
        home: SafeArea(
            child: Scaffold(
          bottomNavigationBar: GlassContainer(
            radius: BorderRadius.circular(0),
            child: FlashyTabBar(
              shadows: [BoxShadow(color: Colors.transparent)],
              //backgroundColor: Colors.transparent,
              height: 55,
              selectedIndex: _selectedIndex,
              showElevation: true,
              onItemSelected: (index) => setState(() {
                _selectedIndex = index;
              }),
              items: [
                FlashyTabBarItem(
                    icon: Icon(Icons.restaurant_menu_outlined),
                    title: Text('Home'),
                    activeColor: navbarcolor,
                    inactiveColor: navbarcolor),
                FlashyTabBarItem(
                    icon: Icon(Icons.search),
                    title: Text('Discover'),
                    inactiveColor: navbarcolor,
                    activeColor: navbarcolor),
                FlashyTabBarItem(
                    icon: Icon(Icons.shopping_bag_outlined),
                    title: Text('Cart'),
                    activeColor: navbarcolor,
                    inactiveColor: navbarcolor),
                FlashyTabBarItem(
                    icon: Icon(Icons.delivery_dining_outlined),
                    title: Text('Tracker'),
                    activeColor: navbarcolor,
                    inactiveColor: navbarcolor),
                FlashyTabBarItem(
                    icon: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                    activeColor: navbarcolor,
                    inactiveColor: navbarcolor),
              ],
            ),
          ),
          body: _selectedIndex != 2
              ? IndexedStack(index: _selectedIndex, children: pageindex)
              : FoodCart(
                  key: UniqueKey(),
                ),
          backgroundColor: Colors.black,
        )));
  }
}

class PanelBody extends StatefulWidget {
  const PanelBody({super.key});

  @override
  State<PanelBody> createState() => _PanelBodyState();
}

class _PanelBodyState extends State<PanelBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Explore explore = Explore();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int cardimageheight =
        (MediaQuery.of(context).size.height * 0.35.round()).toInt();
    var images = [
      "assets/food/1.jpeg",
      "assets/food/2.jpeg",
      "assets/food/3.jpeg"
    ];
    var logos = [
      "assets/rl/bistro.jpg",
      "assets/rl/bloscafe.png",
      "assets/rl/flakkacloud.png",
    ];
    var names = ["Bistro's Dinar", "Blos Cafe", "Black Bamboo"];
    var mainsilverbody = SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Column(children: [
        SearchBarAnimation(
            buttonColour: Colors.black,
            searchBoxColour: Colors.black,
            textEditingController: TextEditingController(),
            isOriginalAnimation: true,
            trailingWidget: const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
            ),
            secondaryButtonWidget: const Icon(Icons.cancel_outlined),
            buttonWidget: const Icon(Icons.location_on_outlined)),

        SizedBox(
          height: height * 0.01,
        ),
        Center(
          child: GlassContainer(
              radius: BorderRadius.circular(2),
              contColor: Colors.transparent,
              borderRadiusColor: Colors.transparent,
              shadowColor: Colors.transparent,
              sigmax: 0,
              sigmay: 0,
              child: Text(
                "   Top Meals   ",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w800),
              )),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        //Top Meals
        GlassContainer(
          contWidth: MediaQuery.of(context).size.width,
          contHeight: MediaQuery.of(context).size.height * 0.28,
          borderRadiusColor: Colors.transparent,
          shadowColor: Colors.transparent,
          contColor: Colors.transparent,
          radius: BorderRadius.zero,
          sigmax: 0,
          sigmay: 0,
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("MenuItem")
                .where("Rating", isGreaterThanOrEqualTo: 4.5)
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var logos = [
                        "assets/burger1.jpg",
                        "assets/burger2.jpg",
                        "assets/wings1.jpeg"
                      ];
                      var names = [
                        "Blondie",
                        "Garlic Cheese Burger",
                        "Buffalo Wings"
                      ];
                      var resturants = [
                        "Bistro's Dinar",
                        "Flakka Cloud",
                        "Blos Cafe"
                      ];
                      var prices = [
                        "R50",
                        "R65",
                        "R95",
                      ];
                      return GlassContainer(
                          shadowColor: Colors.transparent,
                          contColor: Colors.transparent,
                          borderRadiusColor: Colors.white,
                          radius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: FillImageCard(
                            borderRadius: 0,
                            tagRunSpacing: 10,
                            tagSpacing: 100,
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.14,
                            heightImage:
                                MediaQuery.of(context).size.height * 0.15,
                            imageProvider: AssetImage(logos[index]),
                            tags: [
                              GlassContainer(
                                  contColor: Colors.white,
                                  child: Text(
                                    "  ${names[index]}  ",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w900,
                                        shadows: [Shadow(color: Colors.black)],
                                        color: Colors.black),
                                  )),
                              GlassContainer(
                                  sigmax: 0,
                                  sigmay: 0,
                                  contColor: Colors.white,
                                  borderRadiusColor: Colors.transparent,
                                  child: Text(
                                    "  ${prices[index]}  ",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  )),
                            ],
                            title: GlassContainer(
                                contColor: Colors.black,
                                borderRadiusColor: Colors.black,
                                shadowColor: Colors.transparent,
                                child: Text(
                                  "  ${resturants[index]}  ",
                                  style: GoogleFonts.lato(
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                    itemCount: 3);
              }
              return LoadingIndicator(indicatorType: Indicator.ballBeat);
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        Center(
          child: Text(
            "For You:",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        //Explore
        explore
      ]);
    }, childCount: 1));

    return Container(
        color: Colors.black38,
        child: Stack(
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
                      expandedWidget: CarouselSlider(
                          items: [
                            RecommendedCard(
                              food: images[0],
                              name: names[0],
                              logo: logos[0],
                            ),
                            RecommendedCard(
                              food: images[1],
                              name: names[1],
                              logo: logos[1],
                            ),
                            RecommendedCard(
                              food: images[2],
                              name: names[2],
                              logo: logos[2],
                            )
                          ],
                          options: CarouselOptions(
                              aspectRatio: 1.9,
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5))),
                      collapsedWidget: CarouselSlider(
                          items: [
                            RecommendedCard(
                              food: images[0],
                              logo: logos[0],
                            ),
                            RecommendedCard(
                              food: images[1],
                              logo: logos[1],
                            ),
                            RecommendedCard(
                              food: images[2],
                              logo: logos[2],
                            )
                          ],
                          options: CarouselOptions(
                              aspectRatio: 1.9,
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5))),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                    children: [
                      FlexibleTextItem(
                        text: 'Kasi Cuisine',
                        collapsedStyle: GoogleFonts.lato(
                            fontSize: 30,
                            shadows: [
                              Shadow(color: Colors.white, offset: Offset(2, 2)),
                              Shadow(
                                  color: Colors.white, offset: Offset(-2, -2))
                            ],
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        expandedStyle: GoogleFonts.lato(
                            shadows: [
                              Shadow(color: Colors.white, offset: Offset(2, 2)),
                              Shadow(
                                  color: Colors.white, offset: Offset(-2, -2))
                            ],
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        expandedAlignment: Alignment.bottomLeft,
                        collapsedAlignment: Alignment.center,
                        expandedPadding: EdgeInsets.all(1),
                      ),
                    ],
                  ),
                ),
                mainsilverbody
              ],
            )
          ],
        ));
  }
}

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("restaurant/").get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GlassContainer(
            contColor: Colors.transparent,
            shadowColor: Colors.transparent,
            borderRadiusColor: Colors.transparent,
            sigmax: 0,
            sigmay: 0,
            //contHeight: MediaQuery.of(context).size.height  * 0.7,
            child: GridView.count(
                controller: ScrollController(),
                mainAxisSpacing: 0,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 1,
                childAspectRatio: 1.1,
                children: snapshot.data == null
                    ? [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: const LoadingIndicator(
                              indicatorType: Indicator.ballBeat,
                              colors: [Colors.white],
                              strokeWidth: 1,
                              backgroundColor: Colors.transparent,
                              pathBackgroundColor: Colors.white,
                            ))
                      ]
                    : List.generate(snapshot.data.docs.length, (index) {
                        return FutureBuilder(
                          future: FirebaseStorage.instance
                              .ref(
                                  snapshot.data.docs[index].data()["CardImage"])
                              .getDownloadURL(),
                          builder: (BuildContext context, AsyncSnapshot snap) {
                            if (snap.hasData) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResturanutCard(
                                                name: snapshot.data.docs[index]
                                                    .data()["Name"],
                                                logo: snapshot.data.docs[index]
                                                    .data()["Logo"],
                                                address: snapshot
                                                    .data.docs[index]
                                                    .data()["Address"],
                                              )),
                                    );
                                  },
                                  child: TransparentImageCard(
                                    borderRadius: 1,
                                    endColor: Colors.transparent,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: MediaQuery.of(context).size.width *
                                        0.99,
                                    imageProvider: NetworkImage(
                                      snap.data,
                                    ),
                                    title: GlassContainer(
                                        radius: BorderRadius.circular(5),
                                        contColor: Colors.white,
                                        borderRadiusColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        contHeight: height * 0.04,
                                        sigmax: 0,
                                        sigmay: 0,
                                        child: Center(
                                            child: Text(
                                          " ${snapshot.data.docs[index].data()["Name"]} ",
                                          style: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 4),
                                        ))),
                                    tags: [
                                      GlassContainer(
                                        radius: BorderRadius.circular(5),
                                        contColor: Colors.transparent,
                                        borderRadiusColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        contHeight:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        sigmax: 0,
                                        sigmay: 0,
                                        child: ListView.separated(
                                          padding: EdgeInsets.only(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              const Icon(
                                            Icons.star,
                                            shadows: [
                                              Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.black,
                                                  offset: Offset(4, 4)),
                                              Shadow(
                                                  blurRadius: 20,
                                                  color: Colors.black,
                                                  offset: Offset(4, 4)),
                                            ],
                                            color: Colors.yellow,
                                            size: 30,
                                          ),
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          itemCount: 5,
                                        ),
                                      ),
                                      GlassContainer(
                                          radius: BorderRadius.circular(1),
                                          contColor: Colors.black,
                                          borderRadiusColor: Colors.black,
                                          shadowColor: Colors.transparent,
                                          //contWidth: MediaQuery.of(context).size.width ,
                                          sigmax: 0,
                                          sigmay: 0,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_pin,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.045,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "  ${snapshot.data.docs[index].data()["Address"]}",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ));
                            } else if (!snap.hasData) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: const LoadingIndicator(
                                    indicatorType: Indicator.ballBeat,
                                    colors: [Colors.black],
                                    strokeWidth: 1,
                                    backgroundColor: Colors.transparent,
                                    pathBackgroundColor: Colors.white,
                                  ));
                            }
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: const LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: [Colors.black],
                                  strokeWidth: 1,
                                  backgroundColor: Colors.transparent,
                                  pathBackgroundColor: Colors.white,
                                ));
                          },
                        );
                      })));
      },
    );
  }
}

class RecommendedCard extends StatelessWidget {
  RecommendedCard({super.key, this.name, this.logo, this.food});
  String? name;
  String? logo;
  String? food;
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        contColor: Colors.transparent,
        borderRadiusColor: Colors.transparent,
        shadowColor: Colors.transparent,
        //contWidth: MediaQuery.of(context).size.width,

        child: Stack(
          children: [
            Image.asset(
              food!,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
            name == null
                ? Container()
                : Align(
                    alignment: Alignment.topCenter,
                    child: GlassContainer(
                      radius: BorderRadius.circular(5),
                      contColor: Colors.black,
                      borderRadiusColor: Colors.black,
                      child: Text(
                        "     ${name!}    ",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
