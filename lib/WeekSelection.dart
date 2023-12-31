
import 'package:calenderselection/CommonWidgets/dayWeekSwitch.dart';
import 'package:calenderselection/CommonWidgets/listviewDesign.dart';
import 'package:calenderselection/CustomTabBar/customtabbar.dart';
import 'package:calenderselection/customTableCalender/customCalenderBuilders.dart';
import 'package:calenderselection/customTableCalender/customCalenderStyle.dart';
import 'package:calenderselection/customTableCalender/customCalenderUtilities.dart';
import 'package:calenderselection/customTableCalender/customDaysOfWeek.dart';
import 'package:calenderselection/customTableCalender/customHeaderStyle.dart';
import 'package:calenderselection/customTableCalender/customTableCalender.dart';
import 'package:flutter/material.dart';
import 'package:calenderselection/HelperVariable.dart';
import 'package:intl/intl.dart';

class WeekSelection extends StatefulWidget {
  final DateTime? _rangeStart;
  final DateTime? _rangeEnd;
  const WeekSelection(this._rangeStart, this._rangeEnd, {Key? key}) : super(key: key);

  @override
  State<WeekSelection> createState() => _WeekSelectionState();
}

class _WeekSelectionState extends State<WeekSelection> {
  late CalendarFormat _calendarFormat;
  late Map<CalendarFormat, String> availableCalenderFormat ;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late List daysList;
  List tabs = ["All", "HDR", "Tech 1", "Follow up"];

  @override
  void initState() {
    super.initState();
    _rangeStart = widget._rangeStart;
    _rangeEnd = widget._rangeEnd;

    seperateWeekDatesSelected();

    daysList = getDaysInBetween(_rangeStart!, _rangeEnd!);
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return ((to.difference(from).inDays +1)/ 7).ceil();
  }

  seperateWeekDatesSelected(){

    final firstJanRangeStart = DateTime(_rangeStart!.year, 1, 1);
    final weekNumberRangeStart = weeksBetween(firstJanRangeStart, _rangeStart!);

    final firstJanRangeEnd = DateTime(_rangeEnd!.year, 1, 1);
    final weekNumberRangeEnd = weeksBetween(firstJanRangeEnd, _rangeEnd!);

    final daysSelected = _rangeEnd!.difference(_rangeStart!).inDays + 1;
    final differenceInWeeks = weekNumberRangeEnd - weekNumberRangeStart;

    if(weekNumberRangeEnd < weekNumberRangeStart){
      //Two different year have been selected
      _calendarFormat = CalendarFormat.twoWeeks;
      availableCalenderFormat = {
        CalendarFormat.twoWeeks: '2 weeks',
      };
    }
    else{
      if(daysSelected < 8){
        if(differenceInWeeks == 0){
          _calendarFormat = CalendarFormat.week;
          availableCalenderFormat = {
            CalendarFormat.week: 'Week',
          };
        }
        else{
          _calendarFormat = CalendarFormat.twoWeeks;
          availableCalenderFormat = {
            CalendarFormat.twoWeeks: '2 weeks',
          };
        }
      }
      else if(daysSelected > 7 && daysSelected < 15){
        if(differenceInWeeks == 1){
          _calendarFormat = CalendarFormat.twoWeeks;
          availableCalenderFormat = {
            CalendarFormat.twoWeeks: '2 weeks',
          };
          //return false;
        }
        else{
          _calendarFormat = CalendarFormat.month;
          availableCalenderFormat = {
            CalendarFormat.month: 'Month',
          };
          //return true;
        }
      }
      else{
        _calendarFormat = CalendarFormat.month;
        availableCalenderFormat = {
          CalendarFormat.month: 'Month',
        };
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCode.white,
      appBar: appBar(),
      body: Column(
        children: [
          calenderDesign(),
          tabBarDesign(),
        ],
      ),
    );
  }

  appBar(){
    return AppBar(
      backgroundColor: colorCode.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 5,),
          InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, size: 26, color: colorCode.black,)),
          const SizedBox(width: 20,),
          const Text("My Calender", style: TextStyle(color: colorCode.black),),
        ],
      ),
      actions: [
        DayWeekSwitch("Week"),
      ],
    );
  }

  calenderDesign(){
    return Container(
      color: colorCode.warmgrey,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: customTableCalendar(
        availableGestures: AvailableGestures.none,
        firstDay: _rangeStart!,
        lastDay: DateTime.utc(2024, 12,),
        focusedDay: _rangeStart!,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        daysOfWeekStyle: const customDaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12,
            color: colorCode.black,
          ),
          weekendStyle: TextStyle(
            fontSize: 12,
            color: colorCode.red,
          ),
        ),
        calendarFormat: _calendarFormat,
        availableCalendarFormats: availableCalenderFormat,
        rangeSelectionMode: _rangeSelectionMode,
        calendarStyle: customCalendarStyle(
            todayTextStyle: const TextStyle(color: colorCode.black),
            todayDecoration: BoxDecoration(
              color: colorCode.white,
              border: Border.all(color: colorCode.blueBorder,width: 2),
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: BoxDecoration(
              color: colorCode.blueFilling,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: colorCode.blueFilling,
              shape: BoxShape.circle,
            ),
          weekendTextStyle: const TextStyle(color: colorCode.red),
        ),
        calendarBuilders: customCalendarBuilders(
          headerTitleBuilder: (context, dateTime)=>headerBuilder(dateTime),
        ),
      ),
    );
  }

  headerBuilder(DateTime dateTime){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${DateFormat("MMMM").format(_rangeStart!)} ${_rangeStart!.day}"),
          const Icon(Icons.arrow_drop_down_outlined),
        ],
      ),
    );
  }


  tabBarDesign(){
    return Expanded(
      child: CustomTabView(
        initPosition: 0,
        isScroll: true,
        itemCount: tabs.length,
        stub: const SizedBox(),
        tabBuilder: (BuildContext, index)=>Tab(text: tabs[index],),
        listCountBuilder: (BuildContext context, int index)=>listItemCount(index),
        pageBuilder: (BuildContext, index){
          return ListView.builder(
            itemCount: daysList.length,
              itemBuilder: (BuildContext, index){
              DateTime obj = daysList[index];
              return DaySelectionList(false, obj);
              },
          );
        },
        onPositionChange: (index){},
        onScroll: (double){},
      ),
    );
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  listItemCount(int index){
    return Text(
        " (${getListNumber(index).toString()})",
    );
  }
  getListNumber(int tab) {
    List istCount = List.generate(10, (index) => null);
    return istCount.length;
  }

}
