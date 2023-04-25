import 'package:cronolab/shared/models/cronolabExceptions.dart';
import 'package:flutter/material.dart';

class ErrosGet extends StatefulWidget {
  const ErrosGet(this.error, {Key? key}) : super(key: key);
  final CronolabException error;
  @override
  State<ErrosGet> createState() => _ErrosGetState();
}

class _ErrosGetState extends State<ErrosGet> {
  @override
  Widget build(BuildContext context) {
    switch (widget.error.code) {
      case 10:
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.signal_wifi_connected_no_internet_4,
                  size: 40,
                  color: Theme.of(context).errorColor),
              const SizedBox(height: 10),
              Text(
                widget.error
                    .toString(),
                textAlign: TextAlign.center,
                style:
                Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        );
      case 11:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.error
                  .toString(),
              style:
              Theme.of(context).textTheme.labelMedium,
            ),
            TextButton(
              child: const Text("Cadastrar turma"),
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed("/minhasTurmas");
                // controllerPage.loadData(
                //     turmas, turmasLocal);
              },
            )
          ],
        );

      case 12:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.error
                  .toString(),
              style:
              Theme.of(context).textTheme.labelMedium,
            ),

          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
             "Erro desconhecido!",
              style:
              Theme.of(context).textTheme.labelMedium,
            ),

          ],
        );
    }
  }
}
