import 'dart:ffi';

import 'package:cocktail_json_based/io.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'nework.dart';
import 'package:http/http.dart' as http;
import 'dropown.dart';
import 'io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cocktail',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    //final String response = await rootBundle.loadString('assets/test.json');
    String response = await readFile("Cocktail.json");
    if (response == "noData"){
      final String _temp = await rootBundle.loadString('assets/test.json');
      writeFile("Cocktail.json", _temp);
      response = await readFile("Cocktail.json");
    }

    final data = await json.decode(response);
    setState(() {
      _items = data;
    });
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Center(
          child: DropdownButtonExample(),
        ),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
 void _onItemTapped(int index) {
    if (index == 1){
      int shownIndex = 1;
      showModal(context);

    }

  }
  Future<List> reduceJson(List items) async {
    List out = [];
    String pumpConfRaw = await readFile("pumpConf.json");
    if (pumpConfRaw == "noData"){
      final String _temp = await rootBundle.loadString('assets/pumpConf.json');
      writeFile("pumpConf.json", _temp);
      pumpConfRaw = await readFile("pumpConf.json");
    }

    List pumpConf = json.decode(pumpConfRaw);
    bool guard = true;
    for (var item in items) {
      item["igredients"].forEach((ingredient){
        if(!((pumpConf.contains(ingredient["name"]))&(guard))){
          guard = false;
        }
      }
      );
      if (guard){
        out.add(item);
      }
      guard = true;
    }
    return out;
  }
  @override
  Widget build(BuildContext context) {
    readJson();

    return FutureBuilder(
      future: reduceJson(_items),
      builder: (context,snapshot){
        if (snapshot.hasData){
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',

                ),
              ],
              onTap: _onItemTapped,
              currentIndex: 0,
            ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Cocktail',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [

                  // Display the data loaded from sample.json

                  _items.isNotEmpty
                      ? Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(snapshot.data![index]["name"]),
                            //title: Text(_items[index]["igredients"][0]["name"]),
                            // subtitle: Text(_items[index]["name"]),

                            onTap: () {
                              _pushEx(snapshot.data![index]);

                            },
                          ),
                        );
                      },
                    ),
                  )
                      : Container()
                ],
              ),
            ),
          );
        }
        else{
          return const CircularProgressIndicator();
        }
      },

    );


  }
  void showWaitWindow(BuildContext context,String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:  Row(
            children:
            [
            FutureBuilder<http.Response>(
              future: postMakeCocktail(body),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  String? str = snapshot.data?.body;
                  return Text(str!);
                }

                  return CircularProgressIndicator();

              },
            )
  ]
        ),
          actions: <TextButton>[
      TextButton(
      onPressed: () {
    Navigator.pop(context);
    },
      child: const Text('Close'),
    )
    ],
      ),
    );
  }
  Future<void> makeCocktail(List cocktail) async {
    List request = [] ;
    String pumpConfRaw = await readFile("pumpConf.json");
    if (pumpConfRaw == "noData"){
      final String _temp = await rootBundle.loadString('assets/pumpConf.json');
      writeFile("pumpConf.json", _temp);
      pumpConfRaw = await readFile("pumpConf.json");
    }
    final pumpConf = await json.decode(pumpConfRaw);

    for (var ingredient in cocktail){
      int pump = pumpConf.indexOf(ingredient["name"])+1 ;
      request.add([pump,ingredient["volume"]]);
    }

    print(request);
    print(cocktail);
   showWaitWindow(context, json.encode(request));
  }
  void _pushEx(final cocktail) {


    //final drink = data["drinks"][0];
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context){
        final info = cocktail["name"];

        return Scaffold(
          appBar:AppBar(
            title: Text(info),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.navigation),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: () => makeCocktail(cocktail["igredients"]),
          ),
          body: Column(
              children:[


                // Display the data loaded from sample.json
                cocktail["igredients"].isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    itemCount: cocktail["igredients"].length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(cocktail["igredients"][index]["name"]),
                          title: Text(cocktail["igredients"][index]["volume"].toString()+" ml"),
                          // subtitle: Text(_items[index]["name"]),

                        ),
                      );
                    },

                  ),

                )
                    : Container(),

              ],
          ),

        );
      }),
    );
  }
}
