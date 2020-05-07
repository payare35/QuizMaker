import 'package:flutter/material.dart';
import 'package:quiz_maker/helper/functions.dart';
import 'package:quiz_maker/services/auth.dart';
import 'package:quiz_maker/services/database.dart';
import 'package:quiz_maker/views/create_quiz.dart';
import 'package:quiz_maker/views/playQuiz.dart';
import 'package:quiz_maker/views/playQuizCopy.dart';
import 'package:quiz_maker/views/signin.dart';
import 'package:quiz_maker/widgets/widgets.dart';

class Home extends StatefulWidget {
  final String uid;
  Home({@required this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = DatabaseService();
  AuthService _auth = AuthService();
  @override
  void initState() {
    databaseService.getQuizData(widget.uid).then((value) {
      setState(() {
        quizStream = value;
      });
    });
    super.initState();
  }

  Widget quizList() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: StreamBuilder(
          stream: quizStream,
          builder: (context, snapshot) {
            return snapshot.data != null
                ? snapshot.data.documents.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.hourglass_empty,
                                size: 60.0,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              "No Quiz Created \n Click on \"+\" to Create Quiz",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "QuickSand"),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return QuizTile(
                            quizImageUrl: snapshot
                                .data.documents[index].data["quizImageUrl"],
                            quizTitle: snapshot
                                .data.documents[index].data["quizTitle"],
                            quizDesc:
                                snapshot.data.documents[index].data["quizDesc"],
                            quizId:
                                snapshot.data.documents[index].data["quizId"],
                            uid: widget.uid,
                          );
                        })
                : Container();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                tooltip: "Sign Out",
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black87,
                ),
                onPressed: () async {
                  await _auth.signOut();
                  await HelperFunctions.saveUserLoggedinDetails(
                      isLoggedIn: false);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignIn()));
                }),
            SizedBox(width: 10.0)
          ]),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateQuiz(widget.uid)));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String quizImageUrl;
  final String quizTitle;
  final String quizDesc;
  final String quizId;
  final String uid;
  QuizTile(
      {this.quizImageUrl,
      this.quizDesc,
      this.quizTitle,
      this.quizId,
      this.uid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PlayQuiz(quizId: this.quizId, uid: this.uid)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        height: 150.0,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(this.quizImageUrl,
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        this.quizTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "QuickSand",
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        this.quizDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "QuickSand",
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
