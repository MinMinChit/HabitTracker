import 'package:flutter/material.dart';
import 'package:habits_tracker/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_tracker/database_helper.dart';
import 'package:habits_tracker/summary_bar_chart_constructor.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateFormat = DateFormat('E, d MMMM').format(DateTime.now());
    DatabaseHelper databaseHelper = DatabaseHelper.instance;

    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(FontAwesomeIcons.house),
              const Text(
                'Habit Tracker',
                style: kTextTitleStyle,
              ),
              Text(
                dateFormat,
                style: kSubTextStyle,
              ),
            ],
          ),
          FutureBuilder(
            future: databaseHelper.fetchAllByGroup(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<dynamic> list = snapshot.data ?? [];
              List<SummaryBarChart> dataSource = [];

              for (var i = 0; i < list.length; i++) {
                double percent = list[i][1]['Success'] /
                    (list[i][1]['Success'] + list[i][2]['UnSuccess']) *
                    100;

                dataSource.add(
                  SummaryBarChart(
                    challengeName: list[i][0]['ChallengeName'],
                    completedPercent: percent.round(),
                  ),
                );
              }
              return Container(
                color: kBgColor,
                height: 300,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SfCartesianChart(
                      plotAreaBorderColor: Colors.black,
                      plotAreaBackgroundColor: kBgColor,
                      title: ChartTitle(
                          text: 'Summary Chart',
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sriracha',
                              fontSize: 15,
                              fontWeight: FontWeight.w400)),
                      series: [
                        BarSeries(
                            width: 0.8,
                            xAxisName: 'Completed Challenge',
                            yAxisName: 'Challenge',
                            name: 'Habit Tracker',
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                            dataSource: dataSource,
                            xValueMapper: (SummaryBarChart sbc, _) =>
                                sbc.challengeName,
                            yValueMapper: (SummaryBarChart sbc, _) =>
                                sbc.completedPercent),
                      ],
                      primaryXAxis: CategoryAxis(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
