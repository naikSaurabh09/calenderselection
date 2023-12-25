
import 'package:flutter/material.dart';
import 'package:calenderselection/HelperVariable.dart';

class DayWeekSwitch extends StatelessWidget {
  DayWeekSwitch(this.selectedOption, {Key? key}) : super(key: key);

  String selectedOption;
  var options = ["Day", "Week"];

  @override
  Widget build(BuildContext context) {
    return dayWeeKTab();
  }

  dayWeeKTab() {
    return Container(
      margin: EdgeInsets.only( right: 20, top: 15,bottom: 15),
      decoration: BoxDecoration(
          color: colorCode.white,
          border: Border.all(color: colorCode.blueBorder),
          borderRadius: BorderRadius.circular(4)
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: <Widget>[
            dayWeektabs(options[0]),
            dayWeektabs(options[1]),
          ],
        ),
      ),
    );
  }

  dayWeektabs(var label) {
    return Container(
      padding:
      const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: selectedOption == label
            ? colorCode.blueFilling
            : Colors.transparent,
        // borderRadius: BorderRadius.all(),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: (label == "Week")?Radius.circular(3):Radius.circular(0),
          bottomLeft: (label == "Week")?Radius.circular(3):Radius.circular(0),

          topRight: (label == "Day")?Radius.circular(3):Radius.circular(0),
          bottomRight: (label == "Day")?Radius.circular(3):Radius.circular(0),

        ),
        //border: Border.all(color: colorCode.blueBorder)

      ),
      child: Text(
          label,
          style:TextStyle(
            fontSize: 12,
            color: selectedOption == label
                ? colorCode.white
                : colorCode.blueFilling,)
      ),
    );
  }

}
