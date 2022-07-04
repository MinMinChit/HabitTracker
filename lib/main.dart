import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_tracker/constants.dart';
import 'package:habits_tracker/screens/challenge_add_screen.dart';
import 'package:habits_tracker/screens/main_screen.dart';

import 'widgets/button_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(HabitsTrackerApp());
}

class HabitsTrackerApp extends StatelessWidget {
  HabitsTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/main_screen': (context) => const MainScreen(),
        '/challenge_add_screen': (context) => const ChallengeAddScreen(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/balancing-time.jpg'),
            Column(
              children: const [
                Text(
                  'Defeat your bad habits with us within a week',
                  style: kTextTitleStyle,
                ),
                Text(
                  'Release bad habits and build yourself to become better.'
                  'Everything is possible with us.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xffa9a9a9),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            ButtonContainer(
              onTap: () {
                Navigator.pushNamed(context, '/main_screen');
              },
              buttonString: 'Get started',
              buttonSign: '➜',
            ),
          ],
        ),
      ),
    );
  }
}
