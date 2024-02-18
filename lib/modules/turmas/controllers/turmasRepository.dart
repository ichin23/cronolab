import 'package:cronolab/modules/dever/dever.dart';
import 'package:cronolab/modules/materia/materia.dart';

abstract class TurmasRepository {
  Future<Map> getData();
  bool checkAdmin(Dever dever);

  Future<List> getParticipantes();

  Future updateDever(Dever dever);
  cadastraDever(Dever dever);
  deleteDever(Dever dever);
  List<Dever> getDeveresFromTurma();

  enterTurma(String turmaId);
  criarTurma(String turmaId, String nomeTurma);
  Future getMaterias();
  addMateria(Materia materia);
  deleteMateria(Materia materia);
  Materia? getMateriaById(int id);
}
