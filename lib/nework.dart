import 'package:http/http.dart' as http;

Future<http.Response> getCocktailJson(String name) async{
  Uri url = Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$name");
  final respone =  await http.get(url);
  print(url);
  return respone;
}