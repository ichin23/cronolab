import 'package:cronolab/modules/cronolab/desktop/index.dart';
import 'package:cronolab/modules/turmas/turmasServerDesktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadDataDesktop extends StatefulWidget {
  const LoadDataDesktop({Key? key}) : super(key: key);

  @override
  State<LoadDataDesktop> createState() => _LoadDataDesktopState();
}

class _LoadDataDesktopState extends State<LoadDataDesktop> {
  Future? future;
  @override
  void initState() {
    super.initState();
    future = context.read<TurmasStateDesktop>().getTurmas(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snap) {
          return snap.connectionState == ConnectionState.done
              ? const HomePageDesktop()
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}
