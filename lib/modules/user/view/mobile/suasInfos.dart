import 'package:cronolab/shared/colors.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
            return snap.data != null
                ? Container(
                    padding: const EdgeInsets.all(15),
                    child: ListView(
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            height: 60,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Email: ${snap.data!.email}",
                              style: Theme.of(context).textTheme.headlineSmall,
                            )),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            TextEditingController newUser =
                                TextEditingController();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                    onClosing: () {},
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(children: [
                                          TextFormField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            decoration: InputDecoration(
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                label: const Text("Novo nome"),
                                                icon: const Icon(Icons.person,
                                                    color: whiteColor),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            controller: newUser,
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                await user
                                                    .updateDisplayName(
                                                        newUser.text)
                                                    .then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              child: const Text("Mudar User"))
                                        ]),
                                      );
                                    }));
                            setState(() {});
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              height: 60,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nome: ${snap.data!.displayName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            TextEditingController newSenha =
                                TextEditingController();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                    onClosing: () {},
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(children: [
                                          TextFormField(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            decoration: InputDecoration(
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                label: const Text("Nova senha"),
                                                icon: Icon(Icons.key,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            controller: newSenha,
                                          ),
                                          TextButton(
                                              onPressed: () async {
                                                await user
                                                    .updatePassword(
                                                        newSenha.text)
                                                    .then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              child: const Text("Mudar Senha"))
                                        ]),
                                      );
                                    }));
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              height: 60,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Senha",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                : Container();
          }),
    );
  }
}
