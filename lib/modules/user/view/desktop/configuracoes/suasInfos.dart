import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SuasInfosDesktop extends StatefulWidget {
  const SuasInfosDesktop({Key? key}) : super(key: key);

  @override
  State<SuasInfosDesktop> createState() => _SuasInfosDesktopState();
}

class _SuasInfosDesktopState extends State<SuasInfosDesktop> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  bool loading = false;
  late UserProvider userP;
  /*User? user;

  getUser() async {
    user = FirebaseAuth.instance.currentUser;
    nome.text = user!.displayName ?? "";
    email.text = user!.email ?? "";
  }*/

  @override
  void initState() {
    userP = GetIt.I.get<UserProvider>();
    super.initState();
    nome.text = userP.nome.value ?? "";
    email.text = userP.email.value ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder(
          future: Future(() {}), //getUser(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              controller: ScrollController(),
              children: [
                TextFormField(
                  controller: nome,
                  style: inputDark,
                  decoration: const InputDecoration(
                      label: Text("Nome"), labelStyle: labelDark),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text("Erro"),
                              content: Text("Não é possível alterar o email"),
                            ));
                  },
                  child: TextFormField(
                      controller: email,
                      style: inputDark,
                      enabled: false,
                      decoration: const InputDecoration(
                          label: Text("Email"), labelStyle: labelDark)),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(primaryDark),
                        textStyle: MaterialStateProperty.all(labelDark)),
                    child: loading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              color: backgroundDark,
                            ),
                          )
                        : const Text(
                            "Salvar",
                            style: labelBlackDark,
                          ),
                    onPressed: () async {
                      /*if (FirebaseAuth.instance.currentUser?.displayName !=
                          nome.text) {
                        setState(() {
                          loading = true;
                        });
                        await FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(nome.text);
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .update({"nome": nome.text});
                        setState(() {
                          loading = false;
                        });
                      }*/
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
