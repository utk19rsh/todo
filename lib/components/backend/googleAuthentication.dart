import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/backend/sharedPreferences.dart';
import 'package:todo/components/frontend/navigation.dart';
import 'package:todo/models/userInfo.dart';
import 'package:todo/views/home/home.dart';

class GoogleAuthentication {
  final BuildContext context;
  final bool mounted;
  GoogleAuthentication(this.context, this.mounted);

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
    signInOption: SignInOption.standard,
  );
  FirebaseAuth fa = FirebaseAuth.instance;
  FirebaseFirestore ff = FirebaseFirestore.instance;
  MySharedPreferences msp = MySharedPreferences();

  Future<String> signInViaGoogle() async {
    GoogleSignInAccount? googleUser = await (googleSignIn.signIn());
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuthentication =
          await googleUser.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );
      try {
        String result = "";
        await fa.signInWithCredential(authCredential).then((value) async {
          final QuerySnapshot resultQuery = await ff
              .collection("AllUsers")
              .where("uID", isEqualTo: fa.currentUser!.email)
              .get();
          late Map<String, dynamic> map;
          if (resultQuery.docs.isEmpty) {
            //HANDLE SIGNUP
            map = {
              "name": googleUser.displayName,
              "email": googleUser.email,
              "profileImageUrl": googleUser.photoUrl,
              "id": googleUser.id,
              "serverAuthCode": googleUser.serverAuthCode,
              "uID": googleUser.email,
              "createdAt": DateTime.now(),
            };
            await ff.collection("AllUsers").doc(googleUser.email).set(map);
            result = "Signup successfull";
          } else {
            //HANDLE LOGIN
            DocumentSnapshot ds = resultQuery.docs.first;
            map = {
              "name": ds["name"],
              "email": ds["email"],
              "profileImageUrl": ds["profileImageUrl"],
              "id": ds["id"],
              "serverAuthCode": ds["serverAuthCode"],
              "uID": ds["uID"],
            };
            result = "Login successfull";
          }
          msp.setPreferences(map);
          if (mounted) {
            Provider.of<Info>(context,listen: false).setUID = map["uID"];
            Navigation(context).pushReplacement(const Home());
          }
        });
        return result;
      } catch (e) {
        return "Something went wrong, please try later!";
      }
    }
    return "Getting second thoughts?";
  }

  signout() {
    googleSignIn.signOut();
    fa.signOut();
  }
}
