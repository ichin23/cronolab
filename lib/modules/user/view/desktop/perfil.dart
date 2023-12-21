import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/minhasTurmas.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/novaSenha.dart';
import 'package:cronolab/modules/user/view/desktop/configuracoes/suasInfos.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PerfilPageDesktop extends StatefulWidget {
  const PerfilPageDesktop({Key? key}) : super(key: key);

  @override
  State<PerfilPageDesktop> createState() => _PerfilPageDesktopState();
}

class _PerfilPageDesktopState extends State<PerfilPageDesktop> {
  final TextEditingController _turmaCode = TextEditingController();
  bool open = false;
  var index = 0;
  var pages = {
    "Minha conta": const SuasInfosDesktop(),
    "Minhas turmas": const MinhasTurmasDesktop(),
    "Alterar senha": const AlteraSenha(),
  };
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cronolab",
          style: TextStyle(color: primaryDark),
        ),
      ),
      body: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8),
                    width: size.width * 0.15,
                    child: ListView.builder(
                        itemCount: pages.length,
                        itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: index == i
                                      ? Theme.of(context).hoverColor
                                      : Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      index = i;
                                    });
                                  },
                                  title: Text(
                                    pages.keys.toList()[i],
                                    style: labelDark,
                                  ),
                                ),
                              ),
                            ))),
              ),
              Container(
                  child: TextButton(
                child: const Text("Sair"),
                onPressed: () {
                  //FirebaseAuth.instance.signOut();
                  GetIt.I.get<UserProvider>().signOut();
                  Navigator.pop(context);
                },
              ))
            ],
          ),
          const RotatedBox(quarterTurns: 1, child: Divider()),
          Expanded(child: pages.values.toList()[index])
        ],
      ),
    );
  }
}
