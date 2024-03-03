import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/dever/view/mobile/filterDever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

enum ShowView { Grid, List }

class GetDeveres extends StatefulWidget {
  const GetDeveres({Key? key}) : super(key: key);

  @override
  State<GetDeveres> createState() => _GetDeveresState();
}

class _GetDeveresState extends State<GetDeveres> {
  var defaultView = ShowView.List;
  TurmasServer turmas = GetIt.I.get<TurmasServer>();
  List? listFilter;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    return Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  debugPrint(
                      (defaultView.index == ShowView.Grid.index).toString());
                  /*if (defaultView.index == ShowView.Grid.index) {
                      defaultView = ShowView.List;
                      FirebaseAnalytics.instance.logEvent(
                          name: "home_view", parameters: {"layout": "list"});
                    } else {
                      defaultView = ShowView.Grid;
                      FirebaseAnalytics.instance.logEvent(
                          name: "home_view", parameters: {"layout": "grid"});
                    }*/
                  debugPrint(defaultView.toString());
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Icon(
                          defaultView.index == ShowView.Grid.index
                              ? Icons.grid_3x3
                              : Icons.list,
                          color: Theme.of(context).primaryColor),
                      Text(
                          defaultView.index == ShowView.Grid.index
                              ? "Grid"
                              : "List",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        listFilter =
                            await filterDever(context, oldList: listFilter);
                        /*if (context.read<Turmas>()
                                          .turmaAtual !=
                                      null) {

                                        turmas.getData(listFilter);

                                        // turmasLocal.getDeveres(
                                        //     turmas
                                        //         .turmaAtual!.id,
                                        //     filter:
                                        //         controllerPage
                                        //             .listFilter);
                                    setState(() {});
                                  }*/
                        debugPrint(listFilter.toString());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: listFilter != null
                                ? listFilter![0] != null ||
                                        listFilter![1] != null
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent
                                : Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: listFilter != null
                                  ? listFilter![0] != null ||
                                          listFilter![1] != null
                                      ? Theme.of(context).colorScheme.background
                                      : Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor,
                            ),
                            Text(
                              "Filtro",
                              style: TextStyle(
                                  color: listFilter != null
                                      ? listFilter![0] != null ||
                                              listFilter![1] != null
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
          turmas.deveres.value.isNotEmpty
              ? SizedBox(
                  height: size.height - padding.top - padding.bottom - 55 - 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: defaultView == ShowView.Grid
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1 / 1.4,
                                    crossAxisCount: size.width < 600
                                        ? 2
                                        : (size.width / 300).round(),
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, i) => DeverTileList(
                                dever: turmas.deveres.value[i],
                                notifyParent: () {
                                  setState(() {});
                                },
                                index: i),
                            itemCount: turmas.deveres.value.length,
                          )
                        : ListView.builder(
                            itemCount: turmas.deveres.value.length,
                            itemBuilder: (context, i) => DeverTileList(
                                dever: turmas.deveres.value[i], index: i)),
                  ),
                )
              : SizedBox(
                  height: size.height - padding.top - padding.bottom - 55 - 50,
                  child: Center(
                      child: Text(
                    "Não há atividades cadastradas",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                )
        ]));
  }
}
