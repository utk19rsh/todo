import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/constants/functions.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/models/userInfo.dart';
import 'package:todo/views/tasks/components/components.dart';

class AllTasks extends StatelessWidget {
  final List<DocumentSnapshot> listOfAllTasks;
  const AllTasks(
    this.listOfAllTasks, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyTextStyle ts = MyTextStyle();
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        centerTitle: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: listOfAllTasks.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          DocumentSnapshot ds = listOfAllTasks[index];
          late String time;
          DateTime taskTime = ds["time"].toDate();
          if (CheckEquality().sameDate(DateTime.now(), taskTime)) {
            // time = "${taskTime.hour}:${taskTime.minute}";
            time = Convertors().formatTime(taskTime);
          } else {
            time = Convertors().formatDateDM(taskTime);
          }
          return TaskTile(
            ds: ds,
            uID: Provider.of<Info>(context, listen: false).uID,
            ts: ts,
            time: time,
          );
        },
      ),
    );
  }
}
