import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, descrpition, correctAnswer, optionSelected;
  OptionTile(
      {@required this.option,
      @required this.descrpition,
      @required this.correctAnswer,
      @required this.optionSelected});
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
        child: Wrap(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: widget.optionSelected == widget.descrpition
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.white,
                border: Border.all(
                    color: widget.optionSelected == widget.descrpition
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7)
                        : Colors.black54,
                    width: 2.0),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.option}",
                style: TextStyle(
                    color: widget.optionSelected == widget.descrpition
                        ? Colors.white
                        : Colors.black54,
                    fontSize: 17.0,
                    fontFamily: "QuickSand"),
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              padding: EdgeInsets.only(top: 8.0),
              child: Wrap(
                children: widget.descrpition
                    .split(" ")
                    .map((word) => Text(
                          "$word ",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "QuickSand"),
                        ))
                    .toList(),
              ),
            )
          ],
        ));
  }
}

class QuestionTile extends StatelessWidget {
  final String question;
  QuestionTile(this.question);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text(
        this.question,
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "QuickSand"),
      ),
    );
  }
}
