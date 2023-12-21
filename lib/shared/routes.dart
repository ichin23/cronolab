import 'package:cronolab/modules/user/controller/userProvider.dart';
import 'package:get_it/get_it.dart';

const baseUrl = "http://localhost:3000";
const headers = {'Content-Type': 'application/json'};
var headersAuth = {
  ...headers,
  "Authorization": "Bearer ${GetIt.I.get<UserProvider>().token.value ?? 'null'}"
};

final login = Uri.parse(baseUrl + "/login");

final getData = Uri.parse(baseUrl + "/getData");
final getTurmas = Uri.parse(baseUrl + "/getTurmas");
final getMaterias = Uri.parse(baseUrl + "/getMaterias");

final addDever = Uri.parse(baseUrl + "/dever");
