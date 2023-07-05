import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarDesktop extends StatefulWidget {
  const AppBarDesktop({Key? key}) : super(key: key);

  @override
  State<AppBarDesktop> createState() => _AppBarDesktopState();
}

class _AppBarDesktopState extends State<AppBarDesktop> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: backgroundDark,
                border:
                    Border(bottom: BorderSide(color: primaryDark, width: 3))),
            //padding: const EdgeInsets.all(8),
            width: size.width,
            height: 46,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      "Cronolab",
                      style: TextStyle(color: primaryDark),
                    )),
                Consumer<TurmasStateDesktop>(builder: (context, turmas, _) {
                  return Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: ListView.builder(
                      itemCount: turmas.turmas.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(0)),
                            color: true ? primaryDark : Colors.transparent,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            turmas.turmas[i].nome,
                            style: const TextStyle(color: backgroundDark),
                          ),
                        ),
                      ),
                    ),
                  ));
                }),
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: primaryDark,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/perfil");
                  },
                )
              ],
            ))
      ],
    );
  }
}
