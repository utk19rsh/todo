import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/components/constants/constants.dart';

class Backend {
  final FirebaseFirestore ff = FirebaseFirestore.instance;

  String _getDocId({DateTime? time}) {
    // 11:59:59.000 PM on 12/12/2999
    int now = time == null
        ? DateTime.now().millisecondsSinceEpoch
        : time.millisecondsSinceEpoch;
    return (32503636799000 - now).toString();
  }

  Future addTask(Map<String, dynamic> map, String uID) async {
    DocumentReference dr = ff.collection("Tasks").doc(uID);
    await dr
        .collection("Tasks")
        .doc(_getDocId(time: map["updatedAt"]))
        .set(map);
    try {
      await dr.update({"updatedAt": map["updatedAt"]});
    } catch (e) {
      await dr.set({"updatedAt": map["updatedAt"]});
    }
  }

  Future updateTask(
    Map<String, dynamic> map,
    String uID,
    String taskDocumentId,
  ) async {
    DocumentReference dr = ff.collection("Tasks").doc(uID);
    await dr.collection("Tasks").doc(taskDocumentId).update(map);
    try {
      await dr.update({"updatedAt": map["updatedAt"]});
    } catch (e) {
      await dr.set({"updatedAt": map["updatedAt"]});
    }
  }

  Future updateTaskStatus(
    String uID,
    String taskDocumentId,
    bool status,
  ) async {
    try {
      DocumentReference dr = ff.collection("Tasks").doc(uID);
      await dr
          .collection("Tasks")
          .doc(taskDocumentId)
          .update({"pending": status});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<DocumentSnapshot>> getAllTasks(String uID) async {
    Query query = ff
        .collection("Tasks")
        .doc(uID)
        .collection("Tasks")
        .orderBy('time', descending: false);
    return (await query.get()).docs;
  }

  Stream<QuerySnapshot> getTasksStream(String? uID) {
    return ff
        .collection("Tasks")
        .doc(uID)
        .collection("Tasks")
        .orderBy('time', descending: false)
        // .where('time', isGreaterThan: DateTime.now())
        .snapshots();
  }

  Future<void> deleteTask(DocumentSnapshot ds, String uID) async {
    try {
      await ff
          .collection("Tasks")
          .doc(uID)
          .collection("Tasks")
          .doc(ds.id)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
    return;
  }

  Future createDummyTasks(String uID) async {
    Map<String, String> tasks = {
      "Step 1": "Contact Utkarsh",
      "Step 2": "Assign him a task",
      "Step 3": "Wait for task completion",
      "Step 4": "Review his submission",
      "Step 5": "Get confused with his techniques",
      "Step 6": "Then get impressed with those techniques",
      "Step 7": "Contact him again",
      "Step 8": "Schedule next round",
      "Step 9": "Wait for him to clear it",
      "Step 10": "Schedule HR round",
      "Step 11": "Offer him a handsome salary",
      "Step 12": "He will join on 1st April",
      "Step 13": "Welcome him to the team",
      "Step 14": "Achieve great things!",
      "Step 15": "Forgive him if this offended anyone.",
    };
    List<DateTime> times = [
      DateTime(2023, 1, 25),
      DateTime(2023, 1, 26),
      DateTime(2023, 2, 6, 18),
      DateTime(2023, 2, 7, 18),
      DateTime(2023, 2, 8, 18),
      DateTime(2023, 2, 9, 18),
      DateTime(2023, 2, 10, 18),
      DateTime(2023, 2, 11, 18),
      DateTime(2023, 2, 12, 18),
      DateTime(2023, 2, 13, 18),
      DateTime(2023, 2, 14, 18),
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 1),
      DateTime(2023, 4, 2),
      DateTime(2023, 4, 2),
    ];

    for (int i = 0; i < tasks.length; i++) {
      DateTime now = DateTime.now();
      Map<String, dynamic> map = {
        "createdAt": now,
        "updatedAt": now,
        "title": tasks.keys.elementAt(i),
        "description": tasks.values.elementAt(i),
        "time": times[i],
        "category": typesOfTasks.keys.elementAt(i % typesOfTasks.length),
        "pending": i > 3,
      };
      await addTask(map, uID);
    }
  }
}
