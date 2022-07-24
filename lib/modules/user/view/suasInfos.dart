import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart' as fonts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: primary2,
        title: const Text("Suas Informações"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Email: ${user.email}",
                  style: const TextStyle(color: white, fontSize: 15),
                )),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                TextEditingController newUser = TextEditingController();
                showModalBottomSheet(
                    backgroundColor: black,
                    context: context,
                    builder: (context) => Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(children: [
                            TextFormField(
                              style: fonts.white,
                              decoration: InputDecoration(
                                  labelStyle: fonts.white,
                                  label: const Text("Novo nome"),
                                  icon: const Icon(Icons.person, color: white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              controller: newUser,
                            ),
                            TextButton(
                                onPressed: () async {
                                  await user
                                      .updateDisplayName(newUser.text)
                                      .then((value) => Navigator.pop(context));
                                },
                                child: const Text("Mudar User"))
                          ]),
                        ));
                setState(() {});
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nome: ${user.displayName}",
                        style: const TextStyle(color: white, fontSize: 15),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: white,
                      )
                    ],
                  )),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                TextEditingController newSenha = TextEditingController();
                showModalBottomSheet(
                    backgroundColor: black,
                    context: context,
                    builder: (context) => Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(children: [
                            TextFormField(
                              style: fonts.white,
                              decoration: InputDecoration(
                                  labelStyle: fonts.white,
                                  label: const Text("Nova senha"),
                                  icon: const Icon(Icons.key, color: white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              controller: newSenha,
                            ),
                            TextButton(
                                onPressed: () async {
                                  await user
                                      .updatePassword(newSenha.text)
                                      .then((value) => Navigator.pop(context));
                                },
                                child: const Text("Mudar Senha"))
                          ]),
                        ));
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Senha",
                        style: TextStyle(color: white, fontSize: 15),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: white,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
