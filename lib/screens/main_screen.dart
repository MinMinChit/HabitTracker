import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_tracker/screens/challenge_page.dart';
import 'homepage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> list = [
    const HomePage(),
    const ChallengePage(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'My home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartSimple),
            label: 'My Challenges',
          ),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Sriracha',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 25, left: 25),
        child: list[index],
      ),
    );
  }
}
