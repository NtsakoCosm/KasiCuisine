

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

class OrderTracker extends StatefulWidget {
  const OrderTracker({super.key});

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                    'assets/track.jpg',
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
                    text: 'Order Tracker ',
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
          ],
        )
      ],
    );
 ;
  }
}