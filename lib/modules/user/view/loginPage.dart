import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cronolab/shared/fonts.dart' as fonts;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding.bottom +
        MediaQuery.of(context).padding.top +
        200;
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 100, 40, 100),
            child: SingleChildScrollView(
              child: Container(
                height: height - padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "CRONOLAB",
                          style: TextStyle(
                              color: white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          style: TextStyle(fontSize: 16, color: white),
                          decoration: InputDecoration(
                              label: Text("Email"),
                              labelStyle: TextStyle(color: white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: white))),
                        ),
                        SizedBox(height: 45),
                        TextFormField(
                          style: TextStyle(fontSize: 16, color: white),
                          decoration: InputDecoration(
                              label: Text("Senha"),
                              labelStyle: TextStyle(color: white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: white))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text("Esqueci minha senha")),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: Size(width - 50, 55),
                              backgroundColor: primary2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: Text("Login",
                              style: TextStyle(
                                  color: black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          onPressed: () {},
                        ),
                        SizedBox(height: 25),
                        TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: Size(width - 50, 55),
                              backgroundColor: white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/google.png",
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text("Entrar com Google",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            try {
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
                              //  if (Platform.operatingSystem.toLowerCase() == "linux" ||
                              //Platform.operatingSystem.toLowerCase() == "windows") {
                              //FirebaseAuthDesktop.instance
                              //    .signInWithCredential(credential);
                              //}
                              //else {
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              //}
                              //TODO: Update Email FirebaseFirestore.instance
                              //     .collection("users-test")
                              //     .doc(FirebaseAuth.instance.currentUser!.uid)
                              //     .update(
                              //         {"email": FirebaseAuth.instance.currentUser!.email});
                              if (!kIsWeb) {
                                OneSignal().setExternalUserId(
                                    FirebaseAuth.instance.currentUser!.uid);
                              }
                              // turmas.getTurmas();
                            } catch (e) {
                              print(e);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Erro", style: fonts.label),
                                        content: Text(
                                            "Ocorreu um erro ao realizar o login"),
                                        backgroundColor: darkPrimary,
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"))
                                        ],
                                      ));
                            }
                          },
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Não possui conta?",
                              style: TextStyle(color: white, fontSize: 16),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text("Cadastre-se",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: primary2,
                                        fontSize: 16)))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
