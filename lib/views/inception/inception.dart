import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo/components/backend/googleAuthentication.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/appBar.dart';
import 'package:todo/components/frontend/screen.dart';
import 'package:todo/components/frontend/snackbar.dart';
import 'package:todo/components/frontend/textStyle.dart';
import 'package:todo/views/home/home.dart';

class Inception extends StatefulWidget {
  const Inception({super.key});

  @override
  State<Inception> createState() => _InceptionState();
}

class _InceptionState extends State<Inception> {
  MyTextStyle ts = MyTextStyle();
  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: white,
      appBar: const ZeroAppBar(),
      body: SizedBox.expand(
        child: Column(
          children: [
            SizedBox(height: s.topPadding),
            textSection(),
            image(),
            signInViaGoogle(s, context),
          ],
        ),
      ),
    );
  }

  Expanded signInViaGoogle(Screen s, BuildContext context) {
    return Expanded(
      child: Center(
        child: SignInWIthGoogle(
          s: s,
          mounted: mounted,
          onTap: () async {
            String response = await GoogleAuthentication(
              context,
              mounted,
            ).signInViaGoogle();
            //TAKING STRING RESPONSE TO DISPLAY ERROR MESSAGES DURING LOGIN TO USER
            if (response.isNotEmpty && mounted) {
              MySnackBar(context).build(response);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (builder) => const Home(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Expanded image() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Lottie.asset("$lottiePath/login.json"),
      ),
    );
  }

  Expanded textSection() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Unleash Your Inner Potential",
              style: ts.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Say 'NO' to procratination.\nFix your schedules.\nGet in routine.\nLet's go!",
              style: ts.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SignInWIthGoogle extends StatelessWidget {
  const SignInWIthGoogle({
    Key? key,
    required this.s,
    required this.mounted,
    required this.onTap,
  }) : super(key: key);
  final bool mounted;
  final Screen s;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String response = await GoogleAuthentication(
          context,
          mounted,
        ).signInViaGoogle();
        if (response.isNotEmpty && mounted) {
          MySnackBar(context).build(response);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (builder) => const Home(),
            ),
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: orange,
        elevation: 5,
        shadowColor: orange,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          width: s.width * 0.75,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "SIGN IN VIA GOOGLE",
                style: TextStyle(
                  color: black,
                  letterSpacing: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20),
              Icon(MdiIcons.google, color: white)
            ],
          ),
        ),
      ),
    );
  }
}
