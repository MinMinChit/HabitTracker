import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habits_tracker/habit_date_constructor.dart';
import 'package:habits_tracker/habits_data_constructor.dart';
import 'package:habits_tracker/widgets/button_container.dart';
import 'package:habits_tracker/constants.dart';
import 'package:habits_tracker/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widgets/category_icon.dart';

Map<int, bool> selectedCategory = {
  0: false,
  1: false,
  2: false,
  3: false,
  4: false,
};

class ChallengeAddScreen extends StatefulWidget {
  const ChallengeAddScreen({Key? key}) : super(key: key);

  @override
  State<ChallengeAddScreen> createState() => _ChallengeAddScreenState();
}

class _ChallengeAddScreenState extends State<ChallengeAddScreen> {
  String challengeName = '';
  List dateListToStore = [];
  List selectedDateList = [];
  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Challenge Yourself',
              style: kTextTitleStyle,
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'Choose a habit to change yourself',
              style: kSubTextStyle,
            ),
            const Text(
              'Bad Habit to Good Ones',
              style: kSubTextStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 1.5,
                  color: kChallengeBorderColor,
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  challengeName = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Challenge Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Sriracha',
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w100,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Categories',
              style: kTextTitleStyle.copyWith(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryIcon(
                    categoriesIconName: '1connection.png',
                    onTap: () {
                      setState(() {
                        selectedCategoryFunction(selectedCategory, 0);
                      });
                    },
                    color:
                        selectedCategory[0] == true ? Colors.blue : Colors.grey,
                  ),
                  CategoryIcon(
                    categoriesIconName: '2financial.png',
                    onTap: () {
                      setState(() {
                        selectedCategoryFunction(selectedCategory, 1);
                      });
                    },
                    color:
                        selectedCategory[1] == true ? Colors.blue : Colors.grey,
                  ),
                  CategoryIcon(
                    categoriesIconName: '3health.png',
                    onTap: () {
                      setState(() {
                        selectedCategoryFunction(selectedCategory, 2);
                      });
                    },
                    color:
                        selectedCategory[2] == true ? Colors.blue : Colors.grey,
                  ),
                  CategoryIcon(
                    categoriesIconName: '4mindset.png',
                    onTap: () {
                      setState(() {
                        selectedCategoryFunction(selectedCategory, 3);
                      });
                    },
                    color:
                        selectedCategory[3] == true ? Colors.blue : Colors.grey,
                  ),
                  CategoryIcon(
                    categoriesIconName: '5productivity.png',
                    onTap: () {
                      setState(() {
                        selectedCategoryFunction(selectedCategory, 4);
                      });
                    },
                    color:
                        selectedCategory[4] == true ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Time to do and don\'t',
              style: kTextTitleStyle.copyWith(
                fontSize: 25,
              ),
            ),
            SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  selectedDateList = args.value;
                });
              },
              selectionMode: DateRangePickerSelectionMode.multiple,
              selectionColor: Colors.black,
              minDate: DateTime.now(),
            ),
            ButtonContainer(
                onTap: () async {
                  String category = '';
                  for (var i = 0; i < selectedCategory.length; i++) {
                    if (selectedCategory[i] == true) {
                      switch (i) {
                        case 0:
                          {
                            category = '1connection.png';
                          }
                          break;
                        case 1:
                          {
                            category = '2financial.png';
                          }
                          break;
                        case 2:
                          {
                            category = '3health.png';
                          }
                          break;
                        case 3:
                          {
                            category = '4mindset.png';
                          }
                          break;
                        case 4:
                          {
                            category = '5productivity.png';
                          }
                          break;
                      }
                    }
                  }
                  for (var i = 0; i < selectedDateList.length; i++) {
                    dateListToStore.add(
                        DateFormat('dd/MM/yyyy').format(selectedDateList[i]));
                  }
                  if (category != '' &&
                      dateListToStore != [] &&
                      challengeName != '') {
                    HabitsDataConstructor habitsData = HabitsDataConstructor(
                      challengeName: challengeName,
                      category: category,
                      datetime: dateListToStore.toString(),
                    );

                    Map<String, dynamic> rowData = habitsData.toMap();
                    int success = await databaseHelper.insert(rowData);

                    List<Map<String, dynamic>> list =
                        await databaseHelper.fetchData(challengeName);

                    if (success != -1) {
                      for (var i = 0; i < dateListToStore.length; i++) {
                        HabitDateConstructor habitsDate = HabitDateConstructor(
                          dateTime: dateListToStore[i],
                          id: list[0]['id'],
                          success: 0,
                        );
                        Map<String, dynamic> rowHabitDate = habitsDate.toMap();

                        await databaseHelper.insertDateHabit(rowHabitDate);
                      }
                    }

                    if (!mounted) return;

                    Navigator.pop(context);
                  }
                },
                buttonString: 'Create my own challenge',
                buttonSign: '+')
          ],
        ),
      ),
    );
  }

  void selectedCategoryFunction(Map<int, bool> selectCategoryMap, int j) {
    for (int i = 0; i < selectCategoryMap.length; i++) {
      if (i == j) {
        selectCategoryMap[i] = true;
      } else {
        selectCategoryMap[i] = false;
      }
    }
  }
}
