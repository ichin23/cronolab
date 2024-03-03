import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:get_it/get_it.dart';

const baseUrl =
    "https://acf9-2804-1a10-ba11-1000-4300-8eac-f36-ba3d.ngrok-free.app";
const headers = {'Content-Type': 'application/json'};
var headersAuth = {
  ...headers,
  "Authorization": "Bearer ${GetIt.I.get<UserProvider>().token.value ?? 'null'}"
};

final login = Uri.parse(baseUrl + "/login");
final cadastro = Uri.parse(baseUrl + "/createUser");

final getData = Uri.parse(baseUrl + "/getData");
final getTurmas = Uri.parse(baseUrl + "/getTurmas");
final getParticipantes = Uri.parse(baseUrl + "/getParticipantes");
final enterTurma = Uri.parse(baseUrl + "/enterTurma");
final criarTurma = Uri.parse(baseUrl + "/criarTurma");
final sairTurma = Uri.parse(baseUrl + "/sairTurma");
final getMaterias = Uri.parse(baseUrl + "/getMaterias");

final dever = Uri.parse(baseUrl + "/dever");
final materia = Uri.parse(baseUrl + "/materia");
final editMateria = Uri.parse(baseUrl + "/editMateria");

final statusDever = Uri.parse(baseUrl + "/statusDever");
