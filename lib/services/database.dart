import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  addUserData(String uid, Map userData) async {
    await Firestore.instance
        .collection("Users")
        .document(uid)
        .setData(userData);
  }

  addQuizData(String uid, Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Quiz")
        .document(quizId)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  addQuestionData(String uid, Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizData(String uid) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Quiz")
        .snapshots();
  }

  getQNAData(String uid, String quizId) async {
    return await Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .getDocuments();
  }
}
