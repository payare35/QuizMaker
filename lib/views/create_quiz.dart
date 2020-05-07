import 'package:flutter/material.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/views/addQuestion.dart';
import 'package:quiz_maker/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  final String uid;
  CreateQuiz(this.uid);
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final formKey = GlobalKey<FormState>();
  final imageUrlKey = GlobalKey<FormFieldState>();
  final quizTitleKey = GlobalKey<FormFieldState>();
  final quizDescription = GlobalKey<FormFieldState>();
  FocusNode quizTitleNode;
  FocusNode quizDescNode;
  FocusNode createQuizNode;
  String quizImageUrl, quizTitle, quizDescriptionVar, quizId;
  DatabaseService databaseService = DatabaseService();
  bool isLoading = false;

  createQuizOnline() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizData = {
        "quizImageUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDescriptionVar,
        "quizId": quizId
      };
      await databaseService
          .addQuizData(widget.uid, quizData, quizId)
          .then((value) {
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                AddQuestion(uid: widget.uid, quizId: quizId)));
      });
    }
  }

  @override
  void initState() {
    quizTitleNode = FocusNode();
    quizDescNode = FocusNode();
    createQuizNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    quizTitleNode.dispose();
    quizDescNode.dispose();
    createQuizNode.dispose();
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
        iconTheme: IconThemeData(color: Colors.black54),
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
                        key: imageUrlKey,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Image Url";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(hintText: "Quiz Image Url"),
                        onFieldSubmitted: (value) {
                          if (imageUrlKey.currentState.validate()) {
                            quizImageUrl = value.toString();
                            FocusScope.of(context).requestFocus(quizTitleNode);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: quizTitleKey,
                        focusNode: quizTitleNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Quiz Title";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(hintText: "Quiz Title"),
                        onFieldSubmitted: (value) {
                          if (quizTitleKey.currentState.validate()) {
                            quizTitle = value.toString();
                            FocusScope.of(context).requestFocus(quizDescNode);
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        key: quizDescription,
                        focusNode: quizDescNode,
                        decoration:
                            InputDecoration(hintText: "Quiz Description"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter the Quiz Description";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (quizDescription.currentState.validate()) {
                            quizDescriptionVar = value.toString();
                            FocusScope.of(context).requestFocus(createQuizNode);
                          }
                        },
                      ),
                      Spacer(),
                      InkWell(
                          focusNode: createQuizNode,
                          onTap: createQuizOnline,
                          child: blueButton(context, "Create Quiz")),
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
