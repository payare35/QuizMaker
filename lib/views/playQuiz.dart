import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/models/quizModel.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/views/showResult.dart';
import 'package:quiz_maker/widgets/play_quiz_widgets.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final String uid;
  PlayQuiz({@required this.quizId, @required this.uid});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int count = 0;
int total = 0;
int correct = 0;
int incorrect = 0;
int notAttempted = 0;

Stream infoStream;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = DatabaseService();
  QuerySnapshot questionSnapshot;
  QuizModel getQuizModelFromDocumentSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuizModel quizModel = QuizModel();
    quizModel.question = questionSnapshot.data["question"];
    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],
    ];

    options.shuffle();
    quizModel.option1 = options[0];
    quizModel.option2 = options[1];
    quizModel.option3 = options[2];
    quizModel.option4 = options[3];
    quizModel.correctOption = questionSnapshot.data["option1"];
    quizModel.isAnswered = false;

    return quizModel;
  }

  @override
  void initState() {
    // print("${widget.quizId}");
    databaseService.getQNAData(widget.uid, widget.quizId).then((value) {
      questionSnapshot = value;
      correct = 0;
      incorrect = 0;
      total = questionSnapshot.documents.length;
      notAttempted = questionSnapshot.documents.length;
      print("$total");
      setState(() {});
    });
    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        // print("this is x $x");
        return [correct, incorrect, notAttempted];
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              questionSnapshot == null
                  ? Container(
                      height: 40.0,
                    )
                  : InfoHeader(length: questionSnapshot.documents.length),
              questionSnapshot == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionSnapshot.documents.length,
                      itemBuilder: (context, index) => QuestionAnswer(
                          questionAnsModel: getQuizModelFromDocumentSnapshot(
                              questionSnapshot.documents[index]),
                          index: index),
                    ),
              Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: Center(
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ShowResult(
                                total: total,
                                correct: correct,
                                incorrect: incorrect)));
                        // showDialog(
                        //     context: context,
                        //     child: AlertDialog(
                        //       contentPadding: EdgeInsets.all(10.0),
                        //       backgroundColor: Colors.yellow,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20.0),
                        //       ),
                        //       content: total == correct
                        //           ? Container(
                        //               height: 250.0,
                        //               child: Stack(
                        //                 children: <Widget>[
                        //                   FlareActor(
                        //                     "assets/flare_animation/Teddy.flr",
                        //                     animation: "success",
                        //                   ),
                        //                   Container(
                        //                     alignment: Alignment.topCenter,
                        //                     margin:
                        //                         EdgeInsets.only(bottom: 5.0),
                        //                     child: Text(
                        //                       "Congratulations You Won!!!",
                        //                       textAlign: TextAlign.center,
                        //                       style: TextStyle(
                        //                           color: Colors.purple,
                        //                           fontSize: 25.0,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontFamily: "QuickSand"),
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //             )
                        //           : Container(
                        //               height: 250.0,
                        //               child: Stack(
                        //                 children: <Widget>[
                        //                   FlareActor(
                        //                     "assets/flare_animation/Teddy.flr",
                        //                     animation: "fail",
                        //                   ),
                        //                   Container(
                        //                     alignment: Alignment.topCenter,
                        //                     child: Text(
                        //                       "Better Luck Next Time",
                        //                       textAlign: TextAlign.center,
                        //                       style: TextStyle(
                        //                           color: Colors.purple,
                        //                           fontSize: 25.0,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontFamily: "QuickSand"),
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //     ));
                      },
                      label: Text("Submit")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionAnswer extends StatefulWidget {
  final QuizModel questionAnsModel;
  final int index;
  QuestionAnswer({this.questionAnsModel, this.index});

  @override
  _QuestionAnswerState createState() => _QuestionAnswerState();
}

class _QuestionAnswerState extends State<QuestionAnswer> {
  String optionSelected = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          QuestionTile(
              "Q. ${widget.index + 1} ${widget.questionAnsModel.question}"),
          InkWell(
            onTap: () {
              if (!widget.questionAnsModel.isAnswered) {
                if (widget.questionAnsModel.option1 ==
                    widget.questionAnsModel.correctOption) {
                  optionSelected = widget.questionAnsModel.option1;
                  widget.questionAnsModel.isAnswered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                } else {
                  optionSelected = widget.questionAnsModel.option1;
                  widget.questionAnsModel.isAnswered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                }
              }
            },
            child: OptionTile(
              option: "A",
              descrpition: widget.questionAnsModel.option1,
              correctAnswer: widget.questionAnsModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          InkWell(
            onTap: () {
              if (!widget.questionAnsModel.isAnswered) {
                if (widget.questionAnsModel.option2 ==
                    widget.questionAnsModel.correctOption) {
                  optionSelected = widget.questionAnsModel.option2;
                  widget.questionAnsModel.isAnswered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                } else {
                  optionSelected = widget.questionAnsModel.option2;
                  widget.questionAnsModel.isAnswered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                }
              }
            },
            child: OptionTile(
              option: "B",
              descrpition: widget.questionAnsModel.option2,
              correctAnswer: widget.questionAnsModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          InkWell(
            onTap: () {
              if (!widget.questionAnsModel.isAnswered) {
                if (widget.questionAnsModel.option3 ==
                    widget.questionAnsModel.correctOption) {
                  optionSelected = widget.questionAnsModel.option3;
                  widget.questionAnsModel.isAnswered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                } else {
                  optionSelected = widget.questionAnsModel.option3;
                  widget.questionAnsModel.isAnswered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                }
              }
            },
            child: OptionTile(
              option: "C",
              descrpition: widget.questionAnsModel.option3,
              correctAnswer: widget.questionAnsModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          InkWell(
            onTap: () {
              if (!widget.questionAnsModel.isAnswered) {
                if (widget.questionAnsModel.option4 ==
                    widget.questionAnsModel.correctOption) {
                  optionSelected = widget.questionAnsModel.option4;
                  widget.questionAnsModel.isAnswered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                } else {
                  optionSelected = widget.questionAnsModel.option4;
                  widget.questionAnsModel.isAnswered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                  print("$correct $notAttempted");
                }
              }
            },
            child: OptionTile(
              option: "D",
              descrpition: widget.questionAnsModel.option4,
              correctAnswer: widget.questionAnsModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      customChip(context, widget.length, "Total"),
                      customChip(
                        context,
                        correct,
                        "Correct",
                      ),
                      customChip(context, incorrect, "Incorrect"),
                      customChip(context, notAttempted, "NotAttempted"),
                    ],
                  ),
                )
              : Container();
        });
  }
}
