// import 'package:cronolab/modules/turmas/turmasLocal.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

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
      statusBarColor: primaryDark,
      systemNavigationBarColor: primaryDark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // var turmas = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text("Gerenciar Perfil"),
      ),
      body: SafeArea(
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.data != null) {
                return SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: FutureBuilder(
                          future: InternetConnectionChecker().hasConnection,
                          builder: (context, snapCheck) {
                            return Row(
                              children: [
                                snapCheck.data == true &&
                                        FirebaseAuth.instance.currentUser!
                                                .photoURL !=
                                            null
                                    ? SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(FirebaseAuth
                                              .instance.currentUser!.photoURL!),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 10),
                                              BoxShadow()
                                            ],
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        child: const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: whiteColor,
                                        )),
                                const SizedBox(width: 30),
                                Text(
                                  snap.data!.displayName.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                /*  TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  TurmasLocal.to.deleteAll();
                                  // turmas.clear();
                                  Get.back();
                                },
                                child: const Text(
                                  "Sair",
                                  style: TextStyle(color: primary),
                                ),
                              ), */
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
                            );
                          }),
                    ),
                    ListTile(
                      title: Text("Suas Informações",
                          style: Theme.of(context).textTheme.labelMedium),
                      onTap: () {
                        Navigator.of(context).pushNamed("/suasInfos");
                      },
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    ListTile(
                      title: Text("Gerenciar Turmas",
                          style: Theme.of(context).textTheme.labelMedium),
                      onTap: () {
                        Navigator.of(context).pushNamed("/minhasTurmas");
                      },
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    ListTile(
                      title: Text("Sair",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        context.read<Turmas>().turmasSQL.deleteAll();
                        context.read<Turmas>().turmasSQL.turmas.clear();
                        // Provider.of<TurmasLocal>(context).deleteAll();
                        // turmas.clear();
                        Navigator.pop(context);
                      },
                      trailing: Icon(Icons.exit_to_app_rounded,
                          color: Theme.of(context).colorScheme.secondary),
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
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: whiteColor,
                              )),
                          const SizedBox(width: 30),
                          OutlinedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
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
                          style: TextStyle(color: whiteColor)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: whiteColor)),
                    ),
                    ListTile(
                      title: const Text("Gerenciar Turmas",
                          style: TextStyle(color: whiteColor)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: whiteColor)),
                    ),
                    ListTile(
                      title: const Text("Sobre o APP",
                          style: TextStyle(color: whiteColor)),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: whiteColor)),
                    ),
                  ]),
                );
              }
            }),
      ),
    );
  }
}
