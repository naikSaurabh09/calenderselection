import 'package:calenderselection/DaySelection.dart';
import 'package:calenderselection/WeekSelection.dart';
import 'package:calenderselection/customTableCalender/customCalenderStyle.dart';
import 'package:calenderselection/customTableCalender/customCalenderUtilities.dart';
import 'package:calenderselection/customTableCalender/customDaysOfWeek.dart';
import 'package:calenderselection/customTableCalender/customHeaderStyle.dart';
import 'package:calenderselection/customTableCalender/customTableCalender.dart';
import 'package:flutter/material.dart';
import 'package:calenderselection/HelperVariable.dart';

class CalenderSelection extends StatefulWidget {
  const CalenderSelection({Key? key}) : super(key: key);

  @override
  State<CalenderSelection> createState() => _CalenderSelectionState();
}

class _CalenderSelectionState extends State<CalenderSelection> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCode.white,
      appBar: appBar(),
      body: Column(
        children: [
          calenderSelection(),
          const SizedBox(height: 30,),
          Center(
            child: InkWell(
              onTap: onProceed,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorCode.blueFilling,
                  ),
                  child: const Text("Proceed",style: TextStyle(color: colorCode.white),)),
            ),
          )
        ],
      ),
    );
  }

  onProceed() async {
    if(_rangeStart == null){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please Select atleast a single date."),
            backgroundColor: colorCode.red,
          ));
      return ;
    }
    if(_rangeEnd != null){
      await Navigator.push(context, MaterialPageRoute(builder: (context)=> WeekSelection(_rangeStart, _rangeEnd)));
    }
    else{
      await Navigator.push(context, MaterialPageRoute(builder: (context)=> DaySelection(_rangeStart)));
    }
    setState(() {
      _focusedDay = DateTime.now();
      _rangeStart = null;
      _rangeEnd= null;
    });
  }

  PreferredSizeWidget appBar(){
    return AppBar(
      backgroundColor: colorCode.white,
      centerTitle: true,
      elevation: 0.6,
      title: const Text("Calender", style: TextStyle(color: colorCode.black),),
    );
  }

  Widget calenderSelection(){
    return Container(
      color: colorCode.warmgrey,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: customTableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2024, 12, ),
        focusedDay: _focusedDay,
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
          leftChevronVisible: true,
          rightChevronVisible: true,
          titleCentered: true,
          formatButtonVisible: false,
        ),
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        shouldFillViewport: false,
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
          rangeStartDecoration: BoxDecoration(
            color: colorCode.blueFilling,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: colorCode.blueFilling,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(color: colorCode.red),
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
          setState(() {
            //_selectedDay = start;
            _focusedDay = focusedDay;
            _rangeStart = start;
            _rangeEnd = end;
            _rangeSelectionMode = RangeSelectionMode.toggledOn;
          });
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
        // calendarBuilders: customCalendarBuilders(
        //   headerTitleBuilder: (context, dateTime)=>headerBuilder(dateTime),
        // ),
      ),
    );
  }

}
