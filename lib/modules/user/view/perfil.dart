import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primary,
      systemNavigationBarColor: primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // var turmas = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text("Gerenciar Perfil"),
      ),
      backgroundColor: black,
      body: SafeArea(
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.data != null) {
                return SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Row(
                        children: [
                          FirebaseAuth.instance.currentUser!.photoURL != null
                              ? SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(FirebaseAuth
                                        .instance.currentUser!.photoURL!),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 20),
                                        BoxShadow()
                                      ],
                                      color: primary,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: primary)),
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: white,
                                  )),
                          const SizedBox(width: 30),
                          Text(
                            snap.data!.displayName.toString(),
                            style: const TextStyle(color: white),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              // turmas.clear();
                              Get.back();
                            },
                            child: const Text(
                              "Sair",
                              style: TextStyle(color: primary),
                            ),
                          ),
                          // OutlinedButton(
                          //     style: ButtonStyle(
                          //         elevation: MaterialStateProperty.all(5),
                          //         backgroundColor:
                          //             MaterialStateProperty.all(primary),
                          //         shape: MaterialStateProperty.all(
                          //             RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //                 side: BorderSide(
                          //                     color: Color(0xffB8DCFF),
                          //                     width: 10)))),
                          //     onPressed: () {},
                          //     child: Text(
                          //       "Entrar",
                          //       style: TextStyle(color: Colors.black87),
                          //     )),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text("Suas Informações",
                          style: TextStyle(color: white)),
                      onTap: () {
                        Get.toNamed("/suasInfos");
                      },
                      trailing:
                          const Icon(Icons.arrow_forward_ios, color: white),
                    ),
                    ListTile(
                      title: const Text("Gerenciar Turmas",
                          style: TextStyle(color: white)),
                      onTap: () {
                        Get.toNamed("/minhasTurmas");
                      },
                      trailing:
                          const Icon(Icons.arrow_forward_ios, color: white),
                    ),
                    ListTile(
                      onTap: () {
                        print(TurmasLocal.to.turmaAtual);
                      },
                      title: const Text("Sobre o APP",
                          style: TextStyle(color: white)),
                      trailing:
                          const Icon(Icons.arrow_forward_ios, color: white),
                    ),
                  ]),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(blurRadius: 20),
                                    BoxShadow()
                                  ],
                                  color: primary,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primary)),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: white,
                              )),
                          const SizedBox(width: 30),
                          OutlinedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  backgroundColor:
                                      MaterialStateProperty.all(primary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(
                                              color: Color(0xffB8DCFF),
                                              width: 10)))),
                              onPressed: () async {
                                final GoogleSignInAccount? account =
                                    await GoogleSignIn().signIn();
                                final GoogleSignInAuthentication? googleAuth =
                                    await account?.authentication;
                                // Create a new credential
                                final credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth?.accessToken,
                                  idToken: googleAuth?.idToken,
                                );

                                // Once signed in, return the UserCredential
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                              },
                              child: const Text(
                                "Entrar",
                                style: TextStyle(color: Colors.black87),
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text("Suas Informações",
                          style: TextStyle(color: white)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: white)),
                    ),
                    ListTile(
                      title: const Text("Gerenciar Turmas",
                          style: TextStyle(color: white)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: white)),
                    ),
                    ListTile(
                      title: const Text("Sobre o APP",
                          style: TextStyle(color: white)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: white)),
                    ),
                  ]),
                );
              }
            }),
      ),
    );
  }
}
