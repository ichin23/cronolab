import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/turmas/turma.dart';
import 'package:cronolab/modules/turmas/view/mobile/components/viewAdmins.dart';
import 'package:cronolab/modules/turmas/view/mobile/components/viewUsers.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:cronolab/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GerenciarAdmins extends StatefulWidget {
  GerenciarAdmins(this.turma, {Key? key}) : super(key: key);
  Turma turma;
  @override
  State<GerenciarAdmins> createState() => _GerenciarAdminsState();
}

class _GerenciarAdminsState extends State<GerenciarAdmins> with TickerProviderStateMixin{

  late TabController tabController ;
  late Turma turma ;
  late Future<Map> future;

  Future<Map> getParticipantes ()async{
    Map results ={};
    results["admins"]=await context.read<Turmas>().turmasFB.getAdmins(widget.turma.id);
    results["participantes"]=await context.read<Turmas>().turmasFB.getParticipantes(widget.turma.id);
    return results;
  }

  void refresh(){
    future=getParticipantes();
    setState(() {


    });
  }

  @override
  void initState() {

    super.initState();
    turma = widget.turma;
    tabController = TabController(length: 2, vsync: this);
    refresh();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gerenciar ${turma.nome}",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
            )),
        bottom: TabBar(
          controller: tabController,
          tabs: [Tab(text: "Administradores"), Tab(text: "Participantes")],
          indicatorColor: darkPrimary,
          labelStyle: TextStyle(
              color: Colors.black45,
              fontSize: 13,
              fontWeight: FontWeight.w800),
          dividerColor: primaryLight,
          labelColor: Colors.black26,
        ),
      ),
      body: FutureBuilder<Map>(
        future:future,
        builder: (context, snap) {
          print(snap.data);
          switch(snap.connectionState){
            case ConnectionState.waiting:
              return Center(child:CircularProgressIndicator());
            case ConnectionState.done:
              return TabBarView(
                controller: tabController,
                children: [ViewAdmins(turma, snap.data!["admins"], refresh), ViewUsers(turma,snap.data!["admins"],  snap.data!["participantes"], refresh)],);
            default:
              return Center(child: Text("Ocorreu algum erro de nossa parte"));
          }

        }
      )
    );
  }
}
