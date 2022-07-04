import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_tracker/database_helper.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

//My Challenges

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  String dateFormat = DateFormat('E, d MMMM').format(DateTime.now());
  String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(FontAwesomeIcons.chartSimple),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'My Challenges',
                          style: kTextTitleStyle,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/challenge_add_screen');
                      },
                      child: const Icon(
                        FontAwesomeIcons.plus,
                        size: 27,
                      ),
                    ),
                  ],
                ),
                Text(
                  dateFormat,
                  textAlign: TextAlign.start,
                  style: kSubTextStyle,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          //Future
          Expanded(
            flex: 6,
            child: FutureBuilder(
              future: databaseHelper.fetchRowFromDateHabitWhereDateTime(date),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Map<String, dynamic>> list = snapshot.data ?? [];
                int count = 0;
                double percent = 0;
                if (list.isNotEmpty) {
                  for (var i = 0; i < list.length; i++) {
                    if (list[i]['Success'] == 1) {
                      count++;
                    }
                  }
                  percent = count / list.length * 100;
                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'You are doing great',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Sriracha',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '$count/${list.length} day goals completed',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                              CircularPercentIndicator(
                                radius: 45,
                                percent: percent / 100,
                                lineWidth: 12,
                                backgroundColor: kBgIndicatorColor,
                                progressColor: Colors.white,
                                circularStrokeCap: CircularStrokeCap.round,
                                center: Text(
                                  '${percent.round()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Sriracha',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            reverse: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ChallengeContainer(
                                  list: list[index],
                                  onTap: () async {
                                    if (list[index]['Success'] != 1) {
                                      await databaseHelper
                                          .updateSuccessHabitDate(
                                        list[index]['id'],
                                        list[index]['DateTime'],
                                        1,
                                      );
                                    } else {
                                      await databaseHelper
                                          .updateSuccessHabitDate(
                                        list[index]['id'],
                                        list[index]['DateTime'],
                                        0,
                                      );
                                    }
                                    setState(() {});
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('There is no challenge in this day');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeContainer extends StatelessWidget {
  const ChallengeContainer({
    Key? key,
    required this.list,
    required this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> list;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(3, 3),
              spreadRadius: -2,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/${list['Category']}'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      list['ChallengeName'].toString(),
                      style: kTextChallengeListStyle,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: list['Success'] == 1
                        ? const AssetImage('assets/images/tick.png')
                        : const AssetImage('assets/images/untick.png'),
                  ),
                ),
              ],
            ),
            Text(
              list['Success'] == 1 ? 'Congratulation Success!' : 'Just do it',
              textAlign: TextAlign.start,
              style: kSubTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
