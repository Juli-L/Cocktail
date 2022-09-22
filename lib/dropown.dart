import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'io.dart';




class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();

}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
   List<String> list = [];





  // Fetch content from the json file
  Future readJson() async {
    //final String response = await rootBundle.loadString('assets/pumpConf.json');

    String response = await readFile("ingredients.json");
    if (response == "noData"){
      final String _temp = await rootBundle.loadString('assets/ingredients.json');
      writeFile("ingredients.json", _temp);
      response = await readFile("ingredients.json");
    }
    String pumpConfRaw = await readFile("pumpConf.json");
    if (pumpConfRaw == "noData"){
      final String _temp = await rootBundle.loadString('assets/pumpConf.json');
      writeFile("pumpConf.json", _temp);
      pumpConfRaw = await readFile("pumpConf.json");
    }
    
    //final String response = await rootBundle.loadString('assets/ingredients.json');
    //final String pumpConfRaw = await rootBundle.loadString('assets/pumpConf.json');
    final data = await json.decode(response);
    final pumpConf = await json.decode(pumpConfRaw);




    return [data,pumpConf];
  }





  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: readJson(),
      builder: (context,snapshot){

        if (snapshot.hasData){
          String valuesStr = "";
          List? data = snapshot.data[0];
          //print(data);
          List? values = snapshot.data[1];
          return Column(

            children:
            [
              Text("Pump1"),
              DropdownButton(
              alignment: Alignment.center,
              underline: Container(),

              items: data?.map((item) {
                return  DropdownMenuItem(
                  value: item.toString(),
                  child: Text(item),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  values![0] = newVal!;
                  valuesStr = json.encode(values);
                  writeFile("pumpConf.json", valuesStr);
                });
              },
              value: values![0],
          ),
              const Spacer(),
              Text("Pump2"),
              DropdownButton(
                alignment: Alignment.center,
                underline: Container(),

                items: data?.map((item) {
                  return  DropdownMenuItem(
                    value: item.toString(),
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    values![1] = newVal!;
                    valuesStr = json.encode(values);
                    writeFile("pumpConf.json", valuesStr);
                  });
                },
                value:  values![1],
              ),
              const Spacer(),
              Text("Pump3"),
              DropdownButton(
                alignment: Alignment.center,
                underline: Container(),

                items: data?.map((item) {
                  return  DropdownMenuItem(
                    value: item.toString(),
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    values![2] = newVal!;
                    valuesStr = json.encode(values);
                    writeFile("pumpConf.json", valuesStr);
                  });
                },
                value:  values![2],
              ),
              const Spacer(),
              Text("Pump4"),
              DropdownButton(
                alignment: Alignment.center,
                underline: Container(),

                items: data?.map((item) {
                  return  DropdownMenuItem(
                    value: item.toString(),
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    values![3] = newVal!;
                    valuesStr = json.encode(values);
                    writeFile("pumpConf.json", valuesStr);
                  });
                },
                value:  values![3],
              ),
      ]
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}
