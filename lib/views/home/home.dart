import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/components/backend/backend.dart';
import 'package:todo/components/backend/sharedPreferences.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/constants/functions.dart';
import 'package:todo/components/frontend/loading.dart';
import 'package:todo/components/frontend/navigation.dart';
import 'package:todo/components/frontend/screen.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/models/userInfo.dart';
import 'package:todo/views/home/components/components.dart';
import 'package:todo/views/tasks/components/components.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  double expandedHeight = 300;
  MyTextStyle ts = MyTextStyle();
  MySharedPreferences msp = MySharedPreferences();
  Backend backend = Backend();
  Convertors convertors = Convertors();
  CheckEquality checkEquality = CheckEquality();
  String uID = "";
  User? user;
  List<DocumentSnapshot> listOfAllTasks = [], listOfUpcomingTasks = [];
  double percentageCompleted = 0;

  final List<IconData> typesOfTasksIcons = typesOfTasks.values.toList();
  late Animation animation;
  late AnimationController animationController;
  late AssetImage appBarBackgroundImage;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    uID = Provider.of<Info>(context, listen: false).uID;
    appBarBackgroundImage = const AssetImage("$imagesPath/bg.png");
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    inception();
    super.initState();
  }

  inception() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uID = sp.getString(msp.uIDKey)!;
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(appBarBackgroundImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Navigation nav = Navigation(context);
    Screen s = Screen(context);
    return StreamBuilder<QuerySnapshot>(
      stream: backend.getTasksStream(uID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        } else {
          listOfAllTasks = snapshot.data!.docs;
          listOfUpcomingTasks = [];
          Map<String, int> taskTypeCount = Map.fromIterables(
            typesOfTasks.keys,
            List.generate(typesOfTasks.length, (index) => 0),
          );
          int pendingTaskCount = 0;
          final DateTime now = DateTime.now();
          for (DocumentSnapshot ds in listOfAllTasks) {
            if (now.isBefore(ds["time"].toDate())) {
              listOfUpcomingTasks.add(ds);
            }
            if (ds["pending"]) pendingTaskCount++;
            taskTypeCount[ds["category"]] = taskTypeCount[ds["category"]]! + 1;
          }
          animationController.reset();
          if (listOfAllTasks.isNotEmpty) {
            double fraction = (listOfAllTasks.length - pendingTaskCount) /
                listOfAllTasks.length;
            percentageCompleted =
                double.parse(fraction.toStringAsFixed(2)) * 100;
            animation =
                Tween<double>(begin: 0, end: percentageCompleted).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.linear,
              ),
            );
          } else {
            animation = Tween<double>(begin: 0, end: 0).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.linear,
              ),
            );
          }
          animationController.forward();
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: listOfAllTasks.isEmpty ? white : backgroundColor,
            drawer: HomeDrawer(
              user: user,
              listOfAllTasks: listOfAllTasks,
              scaffoldKey: scaffoldKey,
              mounted: mounted,
            ),
            floatingActionButton: HomeFloatingActionButton(nav: nav, s: s),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                appBar(s, taskTypeCount["Personal"]!, taskTypeCount["Work"]!),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "UPCOMING TASKS",
                            style: ts.buttonText,
                          ),
                        ),
                        if (listOfUpcomingTasks.isEmpty)
                          Center(
                            child: Lottie.asset(
                              "$lottiePath/noResult.json",
                            ),
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: listOfUpcomingTasks.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = listOfUpcomingTasks[index];
                            late String time;
                            DateTime taskTime = ds["time"].toDate();
                            if (checkEquality.sameDate(
                                DateTime.now(), taskTime)) {
                              // time = "${taskTime.hour}:${taskTime.minute}";
                              time = convertors.formatTime(taskTime);
                            } else {
                              time = convertors.formatDateDM(taskTime);
                            }
                            return TaskTile(
                              ds: ds,
                              uID: uID,
                              ts: ts,
                              time: time,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  SliverAppBar appBar(Screen s, int personalCount, int workCount) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      collapsedHeight: 0,
      centerTitle: true,
      elevation: 10,
      expandedHeight: expandedHeight,
      floating: false,
      toolbarHeight: 0,
      forceElevated: true,
      foregroundColor: theme,
      pinned: true,
      snap: false,
      stretch: true,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: trans,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: LayoutBuilder(
          builder: (context, constraints) => Stack(
            alignment: Alignment.bottomLeft,
            children: [
              backgroundImage(s),
              overlayEffect(s, constraints),
              Container(
                height:
                    constraints.maxHeight - s.topPadding - kToolbarHeight / 1.5,
                width: s.width,
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerButton(),
                    const SizedBox(height: 15),
                    stats(personalCount, workCount),
                    const Spacer(flex: 3),
                    circularPercentageIndicator(),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
              linearIndicator(s),
            ],
          ),
        ),
      ),
    );
  }

  Positioned linearIndicator(Screen s) {
    return Positioned(
      bottom: 0,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => Container(
          height: 5,
          width: s.width * (animation.value / 100),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [theme, secondaryTheme],
              stops: [0.25, 0.9],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Row circularPercentageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          " ${Convertors().formatDateMDY(DateTime.now())}",
          style: ts.content,
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Row(
            children: [
              CircularProgressIndicator(
                value: animation.value / 100,
                color: secondaryTheme,
                backgroundColor: theme.withOpacity(0.375),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                  "${(animation.value).toInt()} % done",
                  style: ts.content,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Row stats(int personalCount, int workCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your\nThings",
          style: TextStyle(
            fontSize: 28,
            color: white,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            AppBarStatElement(
              "Personal",
              personalCount,
            ),
            AppBarStatElement(
              "Work",
              workCount,
            ),
          ],
        )
      ],
    );
  }

  Transform drawerButton() {
    return Transform.translate(
      offset: const Offset(-10, -10),
      child: IconButton(
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
        icon: const Icon(MdiIcons.menu, color: white, size: 32),
      ),
    );
  }

  Align overlayEffect(Screen s, BoxConstraints constraints) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => SizedBox(
          width: s.width * (1 - (animation.value / 100)),
          height: constraints.maxHeight,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0,
              sigmaY: 0,
            ),
            child: Container(
              color: black.withOpacity(0.25),
            ),
          ),
        ),
      ),
    );
  }

  Container backgroundImage(Screen s) {
    return Container(
      padding: EdgeInsets.only(
        top: s.topPadding == 0 ? 15 : s.topPadding,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          isAntiAlias: true,
          image: appBarBackgroundImage,
        ),
      ),
    );
  }
}
