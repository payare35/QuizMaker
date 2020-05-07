import 'package:flutter/material.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  final String uid;
  AddQuestion({this.quizId, this.uid});
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final questionKey = GlobalKey<FormFieldState>();
  final option1Key = GlobalKey<FormFieldState>();
  final option2Key = GlobalKey<FormFieldState>();
  final option3Key = GlobalKey<FormFieldState>();
  final option4Key = GlobalKey<FormFieldState>();

  FocusNode option1Node;
  FocusNode option2Node;
  FocusNode option3Node;
  FocusNode option4Node;

  DatabaseService databaseService = DatabaseService();

  String question, option1, option2, option3, option4;
  uploadQuestionData() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> quizData = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };
      await databaseService
          .addQuestionData(widget.uid, quizData, widget.quizId)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    option1Node = FocusNode();
    option2Node = FocusNode();
    option3Node = FocusNode();
    option4Node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    option1Node.dispose();
    option2Node.dispose();
    option3Node.dispose();
    option4Node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        // iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        key: questionKey,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Question";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(hintText: "Question"),
                        onFieldSubmitted: (value) {
                          if (questionKey.currentState.validate()) {
                            question = value.toString();
                            FocusScope.of(context).requestFocus(option1Node);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: option1Key,
                        focusNode: option1Node,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter First Option";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Option1 (Correct Answer)"),
                        onFieldSubmitted: (value) {
                          if (option1Key.currentState.validate()) {
                            option1 = value.toString();
                            FocusScope.of(context).requestFocus(option2Node);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: option2Key,
                        focusNode: option2Node,
                        decoration: InputDecoration(hintText: "Option2"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Second Option";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (option2Key.currentState.validate()) {
                            option2 = value.toString();
                            FocusScope.of(context).requestFocus(option3Node);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: option3Key,
                        focusNode: option3Node,
                        decoration: InputDecoration(hintText: "Option3"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Third Option";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (option3Key.currentState.validate()) {
                            option3 = value.toString();
                            FocusScope.of(context).requestFocus(option4Node);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: option4Key,
                        focusNode: option4Node,
                        decoration: InputDecoration(hintText: "Option4"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Fourth Option";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (option4Key.currentState.validate()) {
                            option4 = value.toString();
                            // FocusScope.of(context).requestFocus(option3Node);
                          }
                        },
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              await uploadQuestionData();
                              Navigator.of(context).pop();
                            },
                            child: blueButton(context, "Submit",
                                buttonWidth:
                                    MediaQuery.of(context).size.width / 2 - 36),
                          ),
                          SizedBox(width: 24),
                          InkWell(
                            onTap: uploadQuestionData,
                            child: blueButton(context, "Add Question",
                                buttonWidth:
                                    MediaQuery.of(context).size.width / 2 - 36),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 70.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
