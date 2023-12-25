import 'package:flutter/material.dart';
import 'package:calenderselection/HelperVariable.dart';
import 'package:url_launcher/url_launcher.dart';

class DaySelectionList extends StatelessWidget {
  bool isDaySelection = true;
  DaySelectionList(this.isDaySelection, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDaySelection?dayListDesign():weekListDesign();
  }

  dayListDesign(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 12, right: 12),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: colorCode.grey,
            offset: Offset(2, 0),
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(8),
        color: colorCode.white,
      ),
      child: Column(
        children: [
          row1(),
          Divider(
            color: colorCode.grey,
          ),
          row2(),
        ],
      ),
    );
  }
  row1(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Balaram Naidu",
              style: TextStyle(
                fontSize: 15,
                color: colorCode.black,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 3,),
            Text("ID: LOREM123456354",
              style: TextStyle(
                fontSize: 13,
                color: colorCode.black,
                fontWeight: FontWeight.normal,
              ),),
            SizedBox(height: 3,),
            RichText(
              text: TextSpan(
                text: "Offered : ",
                style: TextStyle(fontSize: 13, color: colorCode.black),
                children: [
                  TextSpan(
                    text: "₹X,XX,XXX",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorCode.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),),
            SizedBox(height: 3,),
            RichText(
              text: TextSpan(
                text: "Current : ",
                style: TextStyle(fontSize: 13, color: colorCode.black),
                children: [
                  TextSpan(
                    text: "₹X,XX,XXX",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorCode.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),),
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: colorCode.golden,),
                SizedBox(width: 8,),
                Text("Medium Priority",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorCode.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
        InkWell(
          onTap: () async{
            final call = Uri.parse('tel:+91 9897657895');
            if (await canLaunchUrl(call)) {
              launchUrl(call);
            } else {
              throw 'Could not launch $call';
            }
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: colorCode.grey,
                  offset: Offset(2, 0),
                  blurRadius: 4,
                )
              ],
              //borderRadius: BorderRadius.circular(8),
              color: colorCode.white,
            ),
            child: Icon(Icons.local_phone_outlined, color: colorCode.blueFilling,),
          ),
        )
      ],
    );
  }
  row2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        columnwiseData("Due Date", "05 Jun 23"),
        columnwiseData("Level", "10"),
        columnwiseData("Days Left", " 23"),
      ],
    );
  }
  columnwiseData(String text, String value, {bool isTotal=false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 16, color: isTotal?colorCode.white:colorCode.black),),
        SizedBox(height: 6,),
        Text(value, style: TextStyle(fontSize: 14, color: colorCode.black, fontWeight: FontWeight.bold)),
      ],
    );
  }


  weekListDesign(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 12, right: 12),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: colorCode.grey,
            offset: Offset(2, 0),
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(8),
        color: colorCode.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 4,
            padding: EdgeInsets.symmetric(vertical: 35),
            decoration: BoxDecoration(
                color: colorCode.red,
                borderRadius: BorderRadius.circular(12)
            ),
          ),
          SizedBox(width: 18,),
          Column(
            children: [
              Text("24", style: TextStyle(fontSize: 16, color: colorCode.black, fontWeight: FontWeight.bold),),
              SizedBox(height: 4,),
              Text("Mar", style: TextStyle(fontSize: 16, color: colorCode.black, fontWeight: FontWeight.bold),),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                columnwiseCircularData("24","HDR",),
                columnwiseCircularData("24","Tech 1",),
                columnwiseCircularData("24","Follow up",),
                columnwiseCircularData("24","Total",isTotal: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  columnwiseCircularData(String value, String text, {bool isTotal=false}){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTotal?colorCode.black:colorCode.white,
              border: Border.all(color: isTotal?Colors.transparent:colorCode.grey)
          ),
          child: Center(child: Text(value, style: TextStyle(fontSize: 16, color: isTotal?colorCode.white:colorCode.black),),),
        ),
        SizedBox(height: 6,),
        Text(text, style: TextStyle(fontSize: 14, color: colorCode.black)),
      ],
    );
  }

}
