import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuasInformacoes extends StatefulWidget {
  const SuasInformacoes({Key? key}) : super(key: key);

  @override
  State<SuasInformacoes> createState() => _SuasInformacoesState();
}

class _SuasInformacoesState extends State<SuasInformacoes> {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        title: const Text("Suas Informações"),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snap) {
            return snap.data!=null? Container(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: [
                  Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      height: 60,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Email: ${snap.data!.email}",
                        style: fonts.input,
                      )),
                  const SizedBox(height: 15),
                 
                  InkWell(
                    onTap: () {
                      TextEditingController newUser = TextEditingController();
                      Get.bottomSheet(BottomSheet(
                          onClosing: () {},
                          backgroundColor: black,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(children: [
                                TextFormField(
                                  style: fonts.white,
                                  decoration: InputDecoration(
                                      labelStyle: fonts.white,
                                      label: const Text("Novo nome"),
                                      icon: const Icon(Icons.person,
                                          color: white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  controller: newUser,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await user
                                          .updateDisplayName(newUser.text)
                                          .then((value) => Get.back());
                                    },
                                    child: const Text("Mudar User"))
                              ]),
                            );
                          }));
                      setState(() {});
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nome: ${snap.data!.displayName}",
                              style: fonts.input,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: primary2,
                            )
                          ],
                        )),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      TextEditingController newSenha = TextEditingController();
                      Get.bottomSheet(BottomSheet(
                          onClosing: () {},
                          backgroundColor: black,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              child: Column(children: [
                                TextFormField(
                                  style: fonts.white,
                                  decoration: InputDecoration(
                                      labelStyle: fonts.white,
                                      label: const Text("Nova senha"),
                                      icon: const Icon(Icons.key, color: primary2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  controller: newSenha,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      await user
                                          .updatePassword(newSenha.text)
                                          .then((value) => Get.back());
                                    },
                                    child: const Text("Mudar Senha"))
                              ]),
                            );
                          }));
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Senha",
                              style: fonts.input,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primary2,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ):Container();
          }),
    );
  }
}
