import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/models/userInfo.dart';
import 'package:todo/views/inception/splashScreen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Info info = Info();
  @override
  void initState() {
    info.assignUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ChangeNotifierProvider(
      create: (context) => info,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do',
        theme: ThemeData(
          primaryColor: theme,
          splashColor: theme.withOpacity(0.25),
          highlightColor: theme.withOpacity(0.25),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            foregroundColor: white,
            elevation: 0,
            centerTitle: true,
            backgroundColor: theme,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: theme,
              statusBarIconBrightness: Brightness.light,
            ),
            iconTheme: const IconThemeData(
              color: white,
            ),
            titleTextStyle: GoogleFonts.nunito(
              textStyle: const TextStyle(
                color: white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(cursorColor: white),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
