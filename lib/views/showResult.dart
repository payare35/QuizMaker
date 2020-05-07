import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ShowResult extends StatefulWidget {
  final int total, correct, incorrect;
  ShowResult(
      {@required this.total, @required this.correct, @required this.incorrect});
  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            widget.correct == widget.total
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height - 48.0,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: FlareActor(
                              "assets/flare_animation/Teddy.flr",
                              animation: "success",
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 150.0),
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Congratulations You Won!!!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "QuickSand"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height - 48.0,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: FlareActor(
                              "assets/flare_animation/Teddy.flr",
                              animation: "fail",
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 120.0),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Total Score: ${widget.correct} / ${widget.total}\nBetter Luck Next Time",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "QuickSand"),
                              )),
                        ],
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
