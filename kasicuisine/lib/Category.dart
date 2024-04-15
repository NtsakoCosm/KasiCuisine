import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glass_container/glass_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_card/image_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class CatagoryScreen extends StatefulWidget {
  CatagoryScreen({super.key, this.img, this.name});
  String? img;
  String? name;

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  var screenindex = 0;
  List<Tab> sorttabs = const [
    Tab(
      text: "Meals",
    ),
    Tab(
      text: "Resturant",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<Widget> categories = [
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("MenuItem")
            .where("Types", arrayContains: widget.name)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
                controller: ScrollController(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                children: List.generate(snapshot.data.docs.length, (index) {
                  
                  return 
                  FutureBuilder(
                    future: FirebaseStorage.instance
                                  .ref(
                                      snapshot.data.docs[index].data()["Image"])
                                  .getDownloadURL(),
                    
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if(snap.hasData){
                        return TransparentImageCard(
                    endColor: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
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
                  );
                
                      }
                      return const LoadingIndicator(indicatorType: Indicator.ballBeat) ;
                    },
                  );
                  }));
          }
          return const  LoadingIndicator(
            indicatorType: Indicator.ballBeat,
          );
        },
      ),
      GridView.count(
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
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
    ];
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: SlidingUpPanel(
            maxHeight: height * 0.7,
            minHeight: width * 0.7,
            color: Colors.transparent,
            isDraggable: false,
            defaultPanelState: PanelState.OPEN,
            body: GlassContainer(
              child: GlassContainer(
                borderRadiusColor: Colors.transparent,
                contHeight: MediaQuery.of(context).size.height * 0.3,
                child: Image.network(
                  "${widget.img}",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
            ),
            panelBuilder: (sc) {
              return GlassContainer(
                  radius: BorderRadius.circular(25),
                  contColor: Colors.white,
                  sigmax: 0,
                  sigmay: 0,
                  //contHeight: height*0.7,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Text(
                      "${widget.name}",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    DefaultTabController(
                      length: sorttabs.length,
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
                        indicatorColor: Colors.black,
                        tabs: sorttabs,

                        // add it here
                        labelColor: Colors.black,
                        indicator: RectangularIndicator(
                          bottomLeftRadius: 100,
                          bottomRightRadius: 100,
                          topLeftRadius: 100,
                          topRightRadius: 100,
                          paintingStyle: PaintingStyle.stroke,
                        ),
                      ),
                    ),
                    categories[screenindex]
                  ])));
            },
          ),
        ),
      ),
    );
  }
}
