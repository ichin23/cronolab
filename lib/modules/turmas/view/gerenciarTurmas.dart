import 'package:cronolab/modules/turmas/turmasProviderServer.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GerenciarTurmas extends StatefulWidget {
  const GerenciarTurmas({Key? key}) : super(key: key);

  @override
  State<GerenciarTurmas> createState() => _GerenciarTurmasState();
}

class _GerenciarTurmasState extends State<GerenciarTurmas> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: darkPrimary,
      systemNavigationBarColor: darkPrimary,
    ));
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    TurmasProvider turmas = Provider.of<TurmasProvider>(context);
    TextEditingController code = TextEditingController();
    // var auth = Provider.of<Auth>(context);
    return
        // Consumer<TurmasProvider>(builder: (context, turmas, child) {
        //   // print(turmas.turmas);
        //   // List turmas = [];
        //   return
        Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text("Gerenciar Turmas"),
        backgroundColor: darkPrimary,
        // actions: [
        //   loading
        //       ? Container(
        //           height: 20, width: 20, child: CircularProgressIndicator())
        //       : Container()
        // ],
      ),
      body: SafeArea(
          child: Consumer<TurmasProvider>(
        builder: (context, turmas, child) => ListView.builder(
            itemCount: turmas.turmas.length,
            itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/turma',
                            arguments: turmas.turmas[i]);
                      },
                      trailing: Icon(
                        Icons.settings,
                        color: white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tileColor: white.withOpacity(0.1),
                      title: Text(turmas.turmas[i].nome,
                          style: const TextStyle(color: white))),
                )),
      )),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: primary,
          onPressed: loading
              ? null
              : () {
                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, setstate) => AlertDialog(
                              backgroundColor: black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: const Text("Adicionar Turma",
                                  style: TextStyle(color: white)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Digite o código da turma",
                                      style: TextStyle(color: white)),
                                  SizedBox(height: 15),
                                  TextField(
                                    decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: darkPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    controller: code,
                                    onSubmitted: (value) {},
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(20)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  darkPrimary),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)))),
                                      onPressed: loading
                                          ? null
                                          : () async {
                                              loading = true;
                                              setstate(() {});

                                              // print("AAAAAAAAAAAAAAAAAAAAA");
                                              await turmas.initTurma(code.text);

                                              // await turmas.enterTurma(code.text, context);
                                              turmas
                                                  .getTurmas()
                                                  .then((value) => setState(() {
                                                        loading = false;
                                                      }));

                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                      child: loading
                                          ? CircularProgressIndicator(
                                              color: black)
                                          : const Text("Adicionar",
                                              style: TextStyle(color: white)))
                                ],
                              ),
                            ),
                          ));
                },
          child: loading
              ? CircularProgressIndicator(
                  color: black,
                )
              : const Icon(
                  Icons.add,
                  color: black,
                  size: 40,
                )),
      // );
      // }
    );
  }
}
