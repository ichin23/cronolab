import 'package:cronolab/shared/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // final turmas = Provider.of(context);
    return Scaffold(
      backgroundColor: black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Login",
              style: GoogleFonts.pacifico(
                  fontSize: 65, color: primary.withAlpha(180)),
            ),
            OutlinedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))))),
                onPressed: () async {
                  final GoogleSignInAccount? account =
                      await GoogleSignIn().signIn();
                  final GoogleSignInAuthentication? googleAuth =
                      await account?.authentication;
                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );

                  // Once signed in, return the UserCredential

                  await FirebaseAuth.instance.signInWithCredential(credential);
                  //TODO: Update Email FirebaseFirestore.instance
                  //     .collection("users-test")
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .update(
                  //         {"email": FirebaseAuth.instance.currentUser!.email});

                  OneSignal().setExternalUserId(
                      FirebaseAuth.instance.currentUser!.uid);
                  // turmas.getTurmas();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.network(
                    //   "https://www.consultoriacdn.com.br/img/googlelogo.png",
                    //   height: 30,
                    // ),

                    Image.asset("assets/image/google.png", height: 30),
                    SizedBox(width: 10),
                    Text("Login com Google")
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
