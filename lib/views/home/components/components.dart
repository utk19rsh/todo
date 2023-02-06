import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/backend/googleAuthentication.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/navigation.dart';
import 'package:todo/components/frontend/screen.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/models/addTasksProvider.dart';
import 'package:todo/views/inception/splashScreen.dart';
import 'package:todo/views/tasks/addTasks.dart';
import 'package:todo/views/tasks/allTasks.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.user,
    required this.listOfAllTasks,
    required this.scaffoldKey,
    required this.mounted,
  }) : super(key: key);

  final User? user;
  final List<DocumentSnapshot<Object?>> listOfAllTasks;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    MyTextStyle ts = MyTextStyle();
    Navigation nav = Navigation(context);
    return Drawer(
      elevation: 10,
      width: s.width * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: s.topPadding),
            DrawerUserInfo(user: user, ts: ts),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {
                nav.push(AllTasks(listOfAllTasks));
                scaffoldKey.currentState!.closeDrawer();
              },
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(theme),
                textStyle: MaterialStatePropertyAll(ts.content),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("View All Tasks"),
                  Icon(MdiIcons.chevronRight),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await GoogleAuthentication(context, mounted).signout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const SplashScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(theme),
                textStyle: MaterialStatePropertyAll(ts.content),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Logout"), Icon(MdiIcons.logout)],
              ),
            ),
            SizedBox(height: s.bottomPadding)
          ],
        ),
      ),
    );
  }
}

class DrawerUserInfo extends StatelessWidget {
  const DrawerUserInfo({
    Key? key,
    required this.user,
    required this.ts,
  }) : super(key: key);

  final User? user;
  final MyTextStyle ts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          color: trans,
          margin: const EdgeInsets.only(right: 20),
          shape: const CircleBorder(),
          child: Image.network(
            user!.photoURL!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            frameBuilder: (
              context,
              Widget child,
              int? frame,
              bool wasSynchronouslyLoaded,
            ) {
              return Center(
                child: frame != null
                    ? child
                    : const CircularProgressIndicator(
                        color: theme,
                      ),
              );
            },
          ),
        ),
        Text(
          user!.displayName!,
          style: ts.buttonText,
        )
      ],
    );
  }
}

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({
    Key? key,
    required this.nav,
    required this.s,
  }) : super(key: key);

  final Navigation nav;
  final Screen s;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        nav.push(
          ChangeNotifierProvider(
            create: (context) => AddTasksProvider(),
            child: const AddTasks(false),
          ),
        );
      },
      child: Card(
        elevation: 20,
        shape: const CircleBorder(),
        color: theme,
        margin: EdgeInsets.only(
          bottom: s.bottomPadding < 5 ? 10 : s.bottomPadding,
        ),
        shadowColor: theme,
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          padding: const EdgeInsets.all(12.5),
          child: const Icon(
            MdiIcons.plus,
            size: 35,
            color: white,
          ),
        ),
      ),
    );
  }
}

class AppBarStatElement extends StatelessWidget {
  final String label;
  final int count;
  const AppBarStatElement(
    this.label,
    this.count, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            count.toString(),
            style: MyTextStyle().heading.copyWith(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: MyTextStyle().content,
          ),
        ],
      ),
    );
  }
}
