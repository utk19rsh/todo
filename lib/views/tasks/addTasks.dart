import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/backend/backend.dart';
import 'package:todo/components/backend/sharedPreferences.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/constants/functions.dart';
import 'package:todo/components/frontend/navigation.dart';
import 'package:todo/components/frontend/snackbar.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/models/addTasksProvider.dart';
import 'package:todo/components/frontend/textFormFields.dart';
import 'package:todo/views/home/home.dart';
import 'package:todo/views/tasks/components/components.dart';

class AddTasks extends StatefulWidget {
  final bool isUpdating;
  const AddTasks(this.isUpdating, {super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MyTextStyle ts = MyTextStyle();
  Convertors convertors = Convertors();
  CheckEquality check = CheckEquality();
  Backend backend = Backend();
  late TextEditingController title, description;
  DateTime now = DateTime.now();
  bool isLoading = true, isUpdating = false;
  String uID = "";
  final Color _secondaryTheme = grey.shade400;
  FocusNode titleFocus = FocusNode(),
      descriptionFocus = FocusNode(),
      dateFocus = FocusNode();

  @override
  void initState() {
    title = TextEditingController(
      text: Provider.of<AddTasksProvider>(context, listen: false).title,
    );
    description = TextEditingController(
      text: Provider.of<AddTasksProvider>(context, listen: false).description,
    );
    isUpdating = widget.isUpdating;
    inception();
    super.initState();
  }

  inception() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uID = sp.getString(MySharedPreferences().uIDKey)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Provider.of<AddTasksProvider>(context, listen: false).clear();
            Navigator.pop(context);
          },
          icon: const Icon(MdiIcons.arrowLeft),
        ),
        title: Text("${isUpdating ? "Edit" : "Add"} Task"),
        actions: [
          GestureDetector(
            onTap: () {
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
                          "Would you like to add sample tasks?",
                          style: ts.contentHeading,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            Navigator.pop(context);
                            MySnackBar(context).build(
                              "Please wait for few seconds...",
                            );
                            await backend.createDummyTasks(uID);
                            if (mounted) {
                              Navigation(context).pushReplacement(const Home());
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 25, bottom: 7.5),
                            child: Row(
                              children: [
                                const Icon(MdiIcons.check, color: theme),
                                const SizedBox(width: 20),
                                Text(
                                  "Yes please!",
                                  style: ts.buttonText
                                      .copyWith(color: grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15, bottom: 12.5),
                            child: Row(
                              children: [
                                const Icon(MdiIcons.cancel, color: red),
                                const SizedBox(width: 20),
                                Text(
                                  "No",
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
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 8,
              ),
              child: Icon(
                MdiIcons.tuneVariant,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Column(
          children: [
            _centerIcon(),
            Expanded(
              child: Form(
                key: formKey,
                child: Consumer<AddTasksProvider>(
                  builder: (context, atp, _) => Column(
                    children: [
                      const SizedBox(height: 40),
                      _taskTitle(atp),
                      _taskDescription(atp),
                      _time(atp),
                      _typeOfTask(atp),
                      const Spacer(),
                      SimpleButton(
                        isProcessing: atp.isProcessing,
                        text: "${isUpdating ? "EDIT" : "ADD"} YOUR THING",
                        onTap: () async => await _submitTask(atp),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DefaultTextStyle _time(AddTasksProvider atp) {
    return DefaultTextStyle(
      style: ts.content.copyWith(color: white),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async => _selectDate(atp),
        child: Container(
          height: 50,
          width: infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _secondaryTheme,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: check.sameTime(atp.time, now)
              ? const Text("Select time")
              : Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async => _selectDate(atp),
                        child: Text(
                          convertors.formatDate(atp.time),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async => _selectTime(atp),
                          child: Text(
                            convertors.formatTime(atp.time),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  MyTextFormFields _taskDescription(AddTasksProvider atp) {
    return MyTextFormFields(
      description,
      focusNode: descriptionFocus,
      secondaryTheme: _secondaryTheme,
      text: atp.description,
      // maxLength: 60 * 3,
      onChanged: (value) => atp.setDescription = value,
      validator: (v) => v!.isEmpty ? "Missing field" : null,
      hintText: "Enter task description",
      labelText: "Description",
      onSuffixTap: () {
        atp.setDescription = "";
        descriptionFocus.unfocus();
        description.clear();
      },
    );
  }

  MyTextFormFields _taskTitle(AddTasksProvider atp) {
    return MyTextFormFields(
      title,
      focusNode: titleFocus,
      secondaryTheme: _secondaryTheme,
      text: atp.title,
      onChanged: (value) => atp.setTitle = value,
      hintText: "Enter task name",
      labelText: "Task Name",
      maxLength: 60,
      inputFormatters: [LengthLimitingTextInputFormatter(60)],
      validator: (v) => v!.isEmpty ? "Missing field" : null,
      onSuffixTap: () {
        atp.setTitle = "";
        titleFocus.unfocus();
        title.clear();
      },
    );
  }

  Padding _typeOfTask(AddTasksProvider atp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: typesOfTasks.entries.map(
          (type) {
            bool selected = atp.selectedTypeOfTask == type.key;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => atp.setSelectedTypeOfTask = type.key,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            type.value,
                            color: selected ? white : _secondaryTheme,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            type.key,
                            style: TextStyle(
                              color: selected ? white : _secondaryTheme,
                              fontSize: 17,
                              letterSpacing: 1,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 17.5,
                      height: 17.5,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1.5,
                          color: selected ? white : _secondaryTheme,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: selected
                            ? const CircleAvatar(backgroundColor: white)
                            : const SizedBox.shrink(),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Container _centerIcon() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: white,
          width: 0.5,
        ),
        gradient: LinearGradient(
          colors: [white.withOpacity(0.5), trans],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        MdiIcons.clipboardEditOutline,
        size: 32,
        color: white,
      ),
    );
  }

  Future _selectDate(AddTasksProvider atp) async {
    DateTime? temp = await showDatePicker(
      context: context,
      initialDate: atp.time.add(
        const Duration(days: 1),
      ),
      firstDate: atp.time,
      lastDate: atp.time.add(
        const Duration(days: 365),
      ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: theme,
            onPrimary: white,
            onSurface: black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: theme,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (temp != null) {
      atp.setDate = DateTime(
        temp.year,
        temp.month,
        temp.day,
        now.hour + 1,
        0,
      );
    }
  }

  Future _selectTime(AddTasksProvider atp) async {
    TimeOfDay? temp = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: atp.time.hour, minute: atp.time.minute),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: theme,
            onPrimary: white,
            onSurface: grey,
            onBackground: grey.shade400,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: theme,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (temp != null) {
      atp.setTime = temp;
    }
  }

  Future _submitTask(AddTasksProvider atp) async {
    if (formKey.currentState!.validate()) {
      if (!check.sameTime(atp.time, now)) {
        atp.updateProcessingStatus = true;
        DateTime now = DateTime.now();
        Map<String, dynamic> map = {
          "createdAt": now,
          "updatedAt": now,
          "title": atp.title,
          "description": atp.description,
          "time": atp.time,
          "category": atp.selectedTypeOfTask,
          "pending": true,
        };
        if (isUpdating) {
          map.remove("createdAt");
          backend.updateTask(map, uID, atp.taskDocumentId);
        } else {
          backend.addTask(map, uID);
        }
        atp.updateProcessingStatus = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const Home()),
          (route) => false,
        );
      } else {
        MySnackBar(context).build("Please select a time.");
      }
    }
  }
}
