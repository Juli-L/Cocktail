,
Center(
child: FutureBuilder<http.Response>(
future: getCocktailJson(info),
builder: (context,snapshot){
if(snapshot.hasData){
int? statuscode = snapshot.data?.statusCode;
String? data = snapshot.data?.body;
final jsonData = json.decode(data!);

if (jsonData["drinks"] == null ){
return(Text("$statuscode"));
}
//return Text(json.decode(data!)["drinks"][0]["strDrinkThumb"]);
return Image.network(json.decode(data!)["drinks"][0]["strDrinkThumb"]);
}
else if (snapshot.hasError){
return Text("${snapshot.error}");
}
return CircularProgressIndicator();
},
)
)



return DropdownButton<String>(
value: dropdownValue,
icon: const Icon(Icons.arrow_downward),
elevation: 16,
style: const TextStyle(color: Colors.deepPurple),
underline: Container(
height: 2,
color: Colors.deepPurpleAccent,
),
onChanged: (String? value) {
// This is called when the user selects an item.
setState(() {
dropdownValue = value!;
});
},

items: list.map<DropdownMenuItem<String>>((String value) {
FutureBuilder(
future: readJson() ,
builder: ,
),
return DropdownMenuItem<String>(
value: value,
child: Text(value),
);
}).toList(),
);
