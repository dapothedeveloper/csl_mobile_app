import 'package:cewers_flutter/custom_widgets/cewer_title.dart';
import 'package:cewers_flutter/custom_widgets/crime-select-indicator.dart';
import 'package:cewers_flutter/custom_widgets/main-container.dart';
import 'package:cewers_flutter/custom_widgets/tabs.dart';
import 'package:cewers_flutter/screens/enter-details.dart';
import 'package:cewers_flutter/style.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SelectCrimeScreen extends StatefulWidget {
  static String route = "/selectCrime";
  _SelectCrimeScreen createState() => _SelectCrimeScreen();
}

class _SelectCrimeScreen extends State<SelectCrimeScreen> {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) => MainContainer(
        decoration: bgDecoration("assets/backgrounds/bg-cloud.png"),
        displayAppBar: CewerAppBar("  Type", "Select"),
        bottomNavigationBar: BottomTab(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              child: Container(
                width: 253,
                padding: EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Column(
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                for (var i = 0; i < iconList.length; i++) {
                                  iconList[i].active = false;
                                  iconList[index].active = true;
                                }
                              });
                            },
                            autoPlay: false,
                            aspectRatio: 1.0,
                            enlargeCenterPage: true,
                          ),
                          items: []..addAll(
                              iconList.map(
                                (image) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EnterDetailScreen(
                                          image.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 600,
                                    margin: EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          SafeArea(
                                            minimum:
                                                EdgeInsets.only(bottom: 50),
                                            child: Image.asset(
                                              "assets/icons/${image.icon}",
                                              fit: BoxFit.contain,
                                              height: 400,
                                            ),
                                          ),
                                          Positioned(
                                            top: 120,
                                            left: 28,
                                            child: Text(image.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .apply(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[]..addAll(iconList
                                .map((icon) => SelectIndicator(icon.active))),
                          ),
                        ),
                        Align(
                          heightFactor: 2,
                          alignment: Alignment.center,
                          child: Text(
                            "< Swipe left or right >",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  List<IconList> iconList = [
    IconList("herdsmen.png", "Herdsmen", true),
    IconList("health.png", "Health", false),
    IconList("violence.png", "Violence", false),
    IconList("crime.png", "Crime", false),
    IconList("fire.png", "Fire   ", false),
  ];
  // final List<Widget> imageSliders = ;
}

class IconList {
  final String icon;
  final String name;
  bool active;
  IconList(this.icon, this.name, this.active);
}
