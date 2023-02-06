import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/backend/backend.dart';
import 'package:todo/components/constants/constants.dart';

class Info extends ChangeNotifier {
  String _uID = "";

  Backend backend = Backend();
  List<DocumentSnapshot> _listOfAllTasks = [], _listOfUpcomingTasks = [];
  int _pendingTasksCount = 0, _percentageCompleted = 0;
  Map<String, int> _taskTypeCount = Map.fromIterables(
    typesOfTasks.keys,
    List.generate(typesOfTasks.length, (index) => 0),
  );

  set setUID(String value) {
    _uID = value;
    notifyListeners();
  }

  List<DocumentSnapshot> get listOfAllTasks => _listOfAllTasks;
  List<DocumentSnapshot> get listOfUpcomingTasks => _listOfUpcomingTasks;
  Map<String, int> get taskTypeCount => _taskTypeCount;
  int get pendingTasksCount => _pendingTasksCount;
  int get percentageCompleted => _percentageCompleted;
  String get uID => _uID;

  assignUid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      _uID = sp.getString("uID")!;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  inception() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      _uID = sp.getString("_uID")!;
      if (_uID.isNotEmpty) {
        _listOfAllTasks = await backend.getAllTasks(_uID);
        _pendingTasksCount = 0;
        for (DocumentSnapshot ds in _listOfAllTasks) {
          if (DateTime.now().isBefore(ds["time"].toDate())) {
            _listOfUpcomingTasks.add(ds);
          }
          _taskTypeCount[ds["category"]] = _taskTypeCount[ds["category"]]! + 1;
          if (ds["pending"]) _pendingTasksCount++;
        }
        double fraction = (_listOfAllTasks.length - _pendingTasksCount) /
            _listOfAllTasks.length;
        _percentageCompleted =
            (double.parse(fraction.toStringAsFixed(2)) * 100).toInt();
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteTask(DocumentSnapshot ds) async {
    if (_uID.isNotEmpty) {
      backend.deleteTask(ds, _uID);
      _listOfAllTasks.remove(ds);
      _listOfUpcomingTasks.remove(ds);
      notifyListeners();
    }
  }

  clear() {
    _listOfAllTasks = [];
    _listOfUpcomingTasks = [];
    _pendingTasksCount = 0;
    _percentageCompleted = 0;
    _taskTypeCount = Map.fromIterables(
      typesOfTasks.keys,
      List.generate(typesOfTasks.length, (index) => 0),
    );
  }
}
