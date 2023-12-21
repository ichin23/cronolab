import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/modules/turmas/controllers/turmas.dart';
import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:cronolab/shared/models/settings.dart';
import 'package:get_it/get_it.dart';

injectDependencies() {
  GetIt.I.registerSingleton(UserProvider());
  GetIt.I.registerSingleton(Settings());
  GetIt.I.registerSingleton(Turmas());
  GetIt.I.registerSingleton(DeveresController());
}
