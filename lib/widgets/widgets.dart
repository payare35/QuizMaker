import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22.0),
      children: <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        TextSpan(
            text: 'Maker',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            )),
      ],
    ),
  );
}

Widget blueButton(BuildContext context, String label, {var buttonWidth}) {
  return Container(
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48.0,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.blue, borderRadius: BorderRadius.circular(25.0)),
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16.0),
    ),
  );
}

Widget customChip(BuildContext context, int count, String label) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    height: 35.0,
    child: Row(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17.5),
                  bottomLeft: Radius.circular(17.5))),
          child: Text(
            "$count",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(17.5),
                  bottomRight: Radius.circular(17.5))),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}
