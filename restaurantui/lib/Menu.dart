import 'package:flutter/material.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final ScrollController _c = ScrollController();
  final ScrollController _c2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
      Image.asset("assets/wall.jpg",fit: BoxFit.cover,height: height,width: width,),
      Container(
        color: Colors.white,
        width: width,
        height: height,
        child: VsScrollbar(
            controller: _c,
            showTrackOnHover: true, // default false
            isAlwaysShown: true, // default false
            scrollbarFadeDuration: const Duration(
                milliseconds: 500), // default : Duration(milliseconds: 300)
            scrollbarTimeToFade: const Duration(
                milliseconds: 800), // default : Duration(milliseconds: 600)
            style: const VsScrollbarStyle(
              hoverThickness: 10.0, // default 12.0
              radius: Radius.circular(10), // default Radius.circular(8.0)
              thickness: 10.0, // [ default 8.0 ]
              color: Colors.black, // default ColorScheme Theme
            ),
            child: SingleChildScrollView(
              controller: _c,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text("Menu Design",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 35)),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Text("(Modify, Add, Remove)",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20)),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  FillImageCard(
                    borderRadius: 25,
                    width: width * 0.4,
                    heightImage: height * 0.2,
                    imageProvider: AssetImage('assets/res2.jpg'),
                    tags: [],
                    title: Text("Bistro's Dinar",
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 22)),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text("Your Cuisine(s)",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 22)),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.25,
                    child: ListView.separated(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var images = [
                            "assets/traditional.jpg",
                            "assets/italian.jpg",
                            "assets/chinese.jpg",
                          ];
                          var names = [
                            "Kasi",
                            "Italian",
                            "Chinese",
                          ];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(names[index],
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18)),
                              GlassContainer(
                                contHeight: height * 0.2,
                                contWidth: width * 0.1,
                                contColor: Colors.transparent,
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: width * 0.1,
                          );
                        },
                        itemCount: 3),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text("Period Based",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 22)),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height * 0.25,
                    child: ListView.separated(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var images = [
                            "assets/bf.jpg",
                            "assets/lunch.jpg",
                            "assets/dinner.jpg",
                          ];
                          var names = [
                            "Breakfast",
                            "Lunch",
                            "Dinner",
                          ];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(names[index],
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18)),
                              GlassContainer(
                                contHeight: height * 0.2,
                                contWidth: width * 0.1,
                                contColor: Colors.transparent,
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: width * 0.1,
                          );
                        },
                        itemCount: 3),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text("By Category",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 22)),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 50,
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    children: List.generate(8, (index) {
                      var images = [
                        "assets/chickencat.jpg",
                        "assets/pizzacat.jpg",
                        "assets/ribscat.jpg",
                        "assets/steakcat.jpg",
                        "assets/ribscat.jpg",
                        "assets/wingscat.jpg",
                        "assets/chisanyamacat.jpg",
                        "assets/burgercat.jpg",
                      ];
                      var names = [
                        "Chicken",
                        "Pizza",
                        "Ribs",
                        "Steak",
                        "Ribs",
                        "Wings",
                        "Chisanyama",
                        "Burger",
                      ];

                      return TransparentImageCard(
                          height: height * 0.4,
                          width: width * 0.3,
                          imageProvider: AssetImage(images[index]),
                          title: Row(children: [
                            Text("${names[index]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25)),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text("8",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25)),
                          ]));
                    }),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                ],
              ),
            )))
      ],
    );
    
  }
}
