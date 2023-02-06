import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/constants/functions.dart';
import 'package:todo/components/frontend/textStyle.dart';

class ViewTask extends StatelessWidget {
  final DocumentSnapshot ds;
  const ViewTask(this.ds, {super.key});

  @override
  Widget build(BuildContext context) {
    Convertors convertors = Convertors();
    return Scaffold(
      appBar: AppBar(title: const Text("View Task Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ViewTaskDetailTile("Title", ds["title"]),
            ViewTaskDetailTile("Description", ds["description"]),
            ViewTaskDetailTile("Task Category", ds["category"]),
            ViewTaskDetailTile(
              "Task Time",
              convertors.formatTDMD(ds["time"].toDate()),
            ),
            ViewTaskDetailTile("Is Pending?", ds["pending"] ? "Yes" : "No"),
            ViewTaskDetailTile(
              "Task Created At",
              convertors.formatTDMD(ds["createdAt"].toDate()),
            ),
            ViewTaskDetailTile(
              "Task Updated At",
              convertors.formatTDMD(ds["updatedAt"].toDate()),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewTaskDetailTile extends StatelessWidget {
  const ViewTaskDetailTile(
    this.label,
    this.value, {
    Key? key,
  }) : super(key: key);

  final String label, value;
  @override
  Widget build(BuildContext context) {
    MyTextStyle ts = MyTextStyle();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 35,
            child: Text(
              label,
              style: ts.contentHeading,
            ),
          ),
          Text(
            " : ",
            style: ts.contentHeading,
          ),
          Expanded(
            flex: 65,
            child: Text(
              value,
              style: ts.description.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
