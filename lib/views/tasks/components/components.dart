import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/backend/backend.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/navigation.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/models/addTasksProvider.dart';
import 'package:todo/views/tasks/addTasks.dart';
import 'package:todo/views/tasks/viewTask.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.isProcessing,
  }) : super(key: key);
  final bool isProcessing;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isProcessing
          ? Container(
              width: infinity,
              height: 60,
              alignment: Alignment.center,
              child: const SizedBox.square(
                dimension: 30,
                child: CircularProgressIndicator(
                  color: white,
                ),
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Container(
                  width: infinity,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: MyTextStyle().buttonText.copyWith(color: theme),
                  ),
                ),
              ),
            ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key? key,
    required this.uID,
    required this.ts,
    required this.ds,
    required this.time,
  }) : super(key: key);

  final DocumentSnapshot ds;
  final MyTextStyle ts;
  final String uID, time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => showTaskBottomSheet(uID, ts, ds, context),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: grey.shade400),
                  ),
                  child: Icon(
                    typesOfTasks[ds["category"]],
                    color: theme,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ds["title"],
                        style: ts.contentHeading,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ds["description"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts.content.copyWith(color: black),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(time),
                    const SizedBox(height: 5),
                    Icon(
                      MdiIcons.check,
                      color: !ds["pending"] ? green : trans,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  showTaskBottomSheet(
    String uID,
    MyTextStyle ts,
    DocumentSnapshot ds,
    BuildContext context,
  ) {
    bool isPending = ds["pending"];
    showModalBottomSheet(
      context: context,
      elevation: 10,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Text(
              "What would you like to do?",
              style: ts.contentHeading,
            ),
            const SizedBox(height: 7.5),
            TaskTileBottomSheetTile(
              color: black,
              icon: MdiIcons.magnify,
              label: "View Task Details",
              ts: ts,
              onTap: () => Navigation(context).push(ViewTask(ds)),
            ),
            TaskTileBottomSheetTile(
              color: isPending ? green : black,
              icon: MdiIcons.check,
              label: "Mark as ${isPending ? "complete" : "incomplete"}",
              ts: ts,
              onTap: () async {
                Navigator.pop(context);
                await Backend().updateTaskStatus(uID, ds.id, !isPending);
              },
            ),
            TaskTileBottomSheetTile(
              color: theme,
              icon: MdiIcons.fileEditOutline,
              label: "Edit Task",
              ts: ts,
              onTap: () => Navigation(context).push(
                ChangeNotifierProvider(
                  create: (context) {
                    AddTasksProvider atp = AddTasksProvider();
                    atp.assign(
                      title: ds["title"],
                      description: ds["description"],
                      selectedTypeOfTask: ds["category"],
                      time: ds["time"].toDate(),
                      taskDocumentId: ds.id,
                    );
                    return atp;
                  },
                  child: const AddTasks(true),
                ),
              ),
            ),
            TaskTileBottomSheetTile(
              color: red,
              icon: MdiIcons.trashCanOutline,
              label: "Delete Task",
              ts: ts,
              onTap: () async => await deleteBottomSheet(uID, ds, context),
            ),
          ],
        ),
      ),
    );
  }

  deleteBottomSheet(
    String uID,
    DocumentSnapshot ds,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Text(
                "Are you sure you want to delete this task?",
                style: ts.contentHeading,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 7.5),
                  child: Row(
                    children: [
                      const Icon(MdiIcons.check, color: theme),
                      const SizedBox(width: 20),
                      Text(
                        "No",
                        style: ts.buttonText.copyWith(color: black),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await Backend().deleteTask(ds, uID);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 12.5),
                  child: Row(
                    children: [
                      const Icon(MdiIcons.cancel, color: red),
                      const SizedBox(width: 20),
                      Text(
                        "Yes",
                        style: ts.buttonText.copyWith(color: red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TaskTileBottomSheetTile extends StatelessWidget {
  final MyTextStyle ts;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const TaskTileBottomSheetTile({
    Key? key,
    required this.ts,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 20),
            Text(
              label,
              style: ts.buttonText.copyWith(color: black),
            ),
          ],
        ),
      ),
    );
  }
}
