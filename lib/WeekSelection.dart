
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
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget._rangeStart;
    _rangeEnd = widget._rangeEnd;
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
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2024, 12, ),
        focusedDay: _rangeStart!,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        startingDayOfWeek: StartingDayOfWeek.monday,
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
        weekendDays: const [DateTime.sunday],
        headerStyle: const customHeaderStyle(
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        calendarFormat: _calendarFormat,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Week',
        },
        rangeSelectionMode: _rangeSelectionMode,
        shouldFillViewport: false,
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
        onDaySelected: (selectedDay, focusedDay) {
          // if (!isSameDay(_selectedDay, selectedDay)) {
          //   setState(() {
          //     _selectedDay = selectedDay;
          //     _focusedDay = focusedDay;
          //     _rangeStart = null; // Important to clean those
          //     _rangeEnd = null;
          //     _rangeSelectionMode = RangeSelectionMode.toggledOff;
          //   });
          // }
        },
        onRangeSelected: (start, end, focusedDay) {
          // setState(() {
          //   _selectedDay = null;
          //   _focusedDay = focusedDay;
          //   _rangeStart = start;
          //   _rangeEnd = end;
          //   _rangeSelectionMode = RangeSelectionMode.toggledOn;
          // });
        },
        onFormatChanged: (format) {
          // if (_calendarFormat != format) {
          //   setState(() {
          //     _calendarFormat = format;
          //   });
          // }
        },
        onPageChanged: (focusedDay) {
          //_focusedDay = focusedDay;
        },
        weekNumbersVisible: false,
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

  List tabs = ["All", "HDR", "Tech 1", "Follow up"];
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
            itemCount: 14,
              itemBuilder: (BuildContext,index)=>DaySelectionList(false),
          );
        },
        onPositionChange: (index){},
        onScroll: (double){},
      ),
    );
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
