import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTile.dart';
import 'package:cronolab/modules/dever/view/mobile/deverTileList.dart';
import 'package:cronolab/modules/dever/view/mobile/filterDever.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ShowView { Grid, List }

class GetDeveres extends StatefulWidget {
  const GetDeveres( this.turmas, {Key? key}) : super(key: key);
  final Turmas turmas;
  @override
  State<GetDeveres> createState() => _GetDeveresState();
}

class _GetDeveresState extends State<GetDeveres> {
  var defaultView=ShowView.List;
  List? listFilter;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    return FutureBuilder<List<Dever>?>(
        future: widget.turmas.turmasSQL.readDeveres(widget.turmas.turmaAtual!.id, listFilter),
        builder: (context, snap) {
          return Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        debugPrint((defaultView.index == ShowView.Grid.index)
                            .toString());
                        if (defaultView.index == ShowView.Grid.index) {
                          defaultView = ShowView.List;
                        } else {
                          defaultView = ShowView.Grid;
                        }
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
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor))
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
                                  await filterDever(context,
                                      oldList:
                                         listFilter);
                              if (context.read<Turmas>()
                                      .turmaAtual !=
                                  null) {

                                    // turmasLocal.getDeveres(
                                    //     turmas
                                    //         .turmaAtual!.id,
                                    //     filter:
                                    //         controllerPage
                                    //             .listFilter);
                                setState(() {});
                              }
                              debugPrint(
                                  listFilter.toString()
                                  );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      //  controllerPage
                                      //             .listFilter !=
                                      //         null
                                      //     ? controllerPage.listFilter![
                                      //                     0] !=
                                      //                 null ||
                                      //             controllerPage.listFilter![
                                      //                     1] !=
                                      //                 null
                                      //         ? Theme.of(
                                      //                 context)
                                      //             .primaryColor
                                      // :
                                      Colors.transparent
                                  // : Colors.transparent
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.filter_list,
                                      color:
                                          // controllerPage
                                          //             .listFilter !=
                                          //         null
                                          //     ? controllerPage.listFilter![
                                          //                     0] !=
                                          //                 null ||
                                          //             controllerPage.listFilter![
                                          //                     1] !=
                                          //                 null
                                          //         ? Theme.of(
                                          //                 context)
                                          //             .backgroundColor
                                          // :
                                          Theme.of(context).primaryColor
                                      // : Theme.of(context)
                                      //     .primaryColor,
                                      ),
                                  Text(
                                    "Filtro",
                                    style: TextStyle(
                                        color:
                                            // controllerPage
                                            //             .listFilter !=
                                            //         null
                                            //     ? controllerPage.listFilter![0] !=
                                            //                 null ||
                                            //             controllerPage.listFilter![1] !=
                                            //                 null
                                            //         ? Theme.of(
                                            //                 context)
                                            //             .backgroundColor
                                            // :
                                            Theme.of(context).primaryColor
                                        // : Theme.of(
                                        //         context)
                                        //     .primaryColor
                                        ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                snap.data!=null && snap.data!.isNotEmpty
                    ? SizedBox(
                        height: size.height -
                            padding.top -
                            padding.bottom -
                            55 -
                            50,
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
                                  itemBuilder: (context, i) => DeverTile(
                                      snap.data![i],
                                      notifyParent: (){
                                        setState(() {

                                        });
                                      },
                                      index: i),
                                  itemCount: snap.data!.length,
                                )
                              : ListView.builder(
                                  itemCount:  snap.data!.length,
                                  itemBuilder: (context, i) =>
                                      DeverTileList(dever:  snap.data![i], index: i)),
                        ),
                      )
                    : SizedBox(
                        height: size.height -
                            padding.top -
                            padding.bottom -
                            55 -
                            50,
                        child: Center(
                            child: Text(
                          "Não há atividades cadastradas",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                      )
              ]));
        });
  }
}
