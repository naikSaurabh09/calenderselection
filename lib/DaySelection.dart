
import 'package:calenderselection/CommonWidgets/dayWeekSwitch.dart';
import 'package:calenderselection/CommonWidgets/listviewDesign.dart';
import 'package:calenderselection/CustomTabBar/customtabbar.dart';
import 'package:calenderselection/customTableCalender/customCalenderStyle.dart';
import 'package:calenderselection/customTableCalender/customHeaderStyle.dart';
import 'package:calenderselection/customTableCalender/customTableCalender.dart';
import 'package:flutter/material.dart';
import 'package:calenderselection/HelperVariable.dart';
import 'package:intl/intl.dart';

import 'customTableCalender/customCalenderBuilders.dart';
import 'customTableCalender/customCalenderUtilities.dart';
import 'customTableCalender/customDaysOfWeek.dart';

class DaySelection extends StatefulWidget {
  DateTime? _selectedDay;
  DaySelection(this._selectedDay,{Key? key}) : super(key: key);

  @override
  State<DaySelection> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  final _calendarFormat = CalendarFormat.week;
  final _rangeSelectionMode = RangeSelectionMode.disabled; // Can be toggled on/off by longpressing a date
  late DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List tabs = ["All", "HDR", "Tech 1", "Follow up"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = widget._selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCode.warmgrey,
      appBar: appBar(),
      body: Column(
        children: [
          Container(
            height: 2,
            color: colorCode.red,
          ),
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
      elevation: 0,
      title: Row(
        children: [
          //SizedBox(width: 5,),
          InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, size: 26, color: colorCode.black,)),
          const SizedBox(width: 20,),
          const Text("In App Calender", style: TextStyle(color: colorCode.black),),
        ],
      ),
      actions: [
        DayWeekSwitch("Day"),
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
        focusedDay: _selectedDay!,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        availableGestures: AvailableGestures.none,
        calendarFormat: _calendarFormat,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Week',
        },
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
        rangeSelectionMode: _rangeSelectionMode,
        headerVisible: true,
        calendarStyle: customCalendarStyle(
          todayTextStyle: const TextStyle(color: colorCode.black),
          todayDecoration: BoxDecoration(
            color: colorCode.white,
            border: Border.all(color: colorCode.blueBorder,width: 2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
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
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      child: Row(
        children: [
          dropDownWithLeftRightArrow(DateFormat("MMM").format(dateTime)),
          const SizedBox(width: 30,),
          dropDownWithLeftRightArrow(dateTime.year.toString()),
        ],
      ),
    );
  }

  dropDownWithLeftRightArrow(String label){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.chevron_left),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                const SizedBox(width: 6,),
                const Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  tabBarDesign(){
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: colorCode.white,
          child: Column(
            children: [
              const SizedBox(height: 15,),
              Center(
                child: Container(
                  height: 5,
                  width:MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      color: colorCode.grey,
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),),
              const SizedBox(height: 20,),
              Expanded(
                child: CustomTabView(
                  initPosition: 0,
                  isScroll: true,
                  itemCount: tabs.length,
                  stub: const SizedBox(),
                  indicatorColor: colorCode.blueFilling,
                  tabBuilder: (BuildContext, index)=>Tab(text: tabs[index],),
                  listCountBuilder: (BuildContext context, int index)=>listItemCount(index),
                  pageBuilder: (BuildContext, index){
                    return ListView.builder(
                      itemCount: 14,
                      itemBuilder: (context, index) => DaySelectionList(true, _selectedDay!),
                    );
                  },
                  onPositionChange: (index){},
                  onScroll: (double){},
                ),
              ),
            ],
          ),
        ),
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
    return istCount?.length ?? 0;

  }

}
