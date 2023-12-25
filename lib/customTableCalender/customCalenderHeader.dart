
import 'package:calenderselection/customTableCalender/customCalenderUtilities.dart';
import 'package:calenderselection/customTableCalender/customFormatButton.dart';
import 'package:calenderselection/customTableCalender/customHeaderStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class customCalendarHeader extends StatelessWidget {
  final dynamic locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final customHeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;

  const customCalendarHeader({
    Key? key,
    this.locale,
    required this.focusedMonth,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onHeaderTap,
    required this.onHeaderLongPress,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
        DateFormat.yMMMM(locale).format(focusedMonth);

    return Container(
      decoration: headerStyle.decoration,
      margin: headerStyle.headerMargin,
      padding: headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (headerStyle.leftChevronVisible)
            IconButton(
              icon: headerStyle.leftChevronIcon,
              onPressed: onLeftChevronTap,
              //margin: headerStyle.leftChevronMargin,
              padding: headerStyle.leftChevronPadding,
            ),
          Expanded(
            child: headerTitleBuilder?.call(context, focusedMonth) ??
                GestureDetector(
                  onTap: onHeaderTap,
                  onLongPress: onHeaderLongPress,
                  child: Text(
                    text,
                    style: headerStyle.titleTextStyle,
                    textAlign: headerStyle.titleCentered
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
          ),
          if (headerStyle.formatButtonVisible &&
              availableCalendarFormats.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: customFormatButton(
                onTap: onFormatButtonTap,
                availableCalendarFormats: availableCalendarFormats,
                calendarFormat: calendarFormat,
                decoration: headerStyle.formatButtonDecoration,
                padding: headerStyle.formatButtonPadding,
                textStyle: headerStyle.formatButtonTextStyle,
                showsNextFormat: headerStyle.formatButtonShowsNext,
              ),
            ),
          if (headerStyle.rightChevronVisible)
            IconButton(
              icon: headerStyle.rightChevronIcon,
              onPressed: onRightChevronTap,
              //margin: headerStyle.rightChevronMargin,
              padding: headerStyle.rightChevronPadding,
            ),
        ],
      ),
    );
  }
}
