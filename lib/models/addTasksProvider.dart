import 'package:flutter/material.dart';

class AddTasksProvider extends ChangeNotifier {
  String _title = "", _description = "", _selectedTypeOfTask = "";
  DateTime _time = DateTime.now();
  bool _isProcessing = false;
  String _taskDocumentId = "";

  set setTaskDocumentId(String value) {
    _taskDocumentId = value;
    notifyListeners();
  }

  set updateProcessingStatus(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  set setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  set setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  set setSelectedTypeOfTask(String value) {
    _selectedTypeOfTask = value;
    notifyListeners();
  }

  set setDate(DateTime value) {
    _time = value;
    notifyListeners();
  }

  set setTime(TimeOfDay value) {
    _time = DateTime(
      _time.year,
      _time.month,
      _time.day,
      value.hour,
      value.minute,
    );
    notifyListeners();
  }

  String get title => _title;
  String get description => _description;
  String get selectedTypeOfTask => _selectedTypeOfTask;
  String get taskDocumentId => _taskDocumentId;
  DateTime get time => _time;
  bool get isProcessing => _isProcessing;

  assign({
    required String title,
    required String description,
    required String selectedTypeOfTask,
    required String taskDocumentId,
    required DateTime time,
  }) {
    _title = title;
    _description = description;
    _selectedTypeOfTask = selectedTypeOfTask;
    _time = time;
    _taskDocumentId = taskDocumentId;
    notifyListeners();
  }

  clear() {
    _title = "";
    _description = "";
    _selectedTypeOfTask = "";
    _time = DateTime.now();
    _taskDocumentId = "";
    notifyListeners();
  }
}
