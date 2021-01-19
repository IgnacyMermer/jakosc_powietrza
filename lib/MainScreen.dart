import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jakosc_powietrza/LoadingScreen.dart';
import 'package:jakosc_powietrza/ShowContamination.dart';
import 'package:jakosc_powietrza/Station.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Station> listOfStationFirst = new List();
  List<Station> listOfStationAfterSort = new List();
  bool isLoaded=false;
  String searchTerm='';

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text("Dane pochodzą z Głównego Inspektoratu Ochrony środowiska(GIOŚ)",textAlign: TextAlign.center,),
              SizedBox(height: 15),
              TextFormField(
                style: TextStyle(fontSize: 22,color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Twoja miejscowość',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900], width: 2.0),
                  ),
                ),
                textAlign: TextAlign.center,

                onChanged: (val) => setState((){

                  List<Station> newList = new List();
                  if(val.substring(0,val.length-1)==searchTerm){
                    for (Station station in listOfStationAfterSort) {

                      String namePom = replaceSpecialChar(station.name
                          .toLowerCase());

                      String valPom = replaceSpecialChar(val.toLowerCase());

                      if (namePom.contains(valPom)) {
                        newList.add(station);
                      }

                    }
                  }
                  else {
                    for (Station station in listOfStationFirst) {

                      String namePom = replaceSpecialChar(station.name
                          .toLowerCase());

                      String valPom = replaceSpecialChar(val.toLowerCase());

                      if (namePom.contains(valPom)) {
                        newList.add(station);
                      }

                    }
                  }
                  searchTerm=val;
                  listOfStationAfterSort=newList;

                }),

              ),

              !isLoaded?FutureBuilder<List<Station>>(
                future:getStation(),
                builder: (context, snapshot){

                  if(snapshot.hasData){
                    isLoaded=true;
                    listOfStationFirst=snapshot.data;
                    listOfStationAfterSort=snapshot.data;

                    return ListOfStationWidget();

                  }
                  else{
                    return LoadingScreen();
                  }
                }
              ):ListOfStationWidget(),
            ],
          )
        ),
      ),
    );
  }

  String replaceSpecialChar(String toReplace){
    toReplace=toReplace.replaceAll("ę", "e");
    toReplace=toReplace.replaceAll("ą", "a");
    toReplace=toReplace.replaceAll("ó", "o");
    toReplace=toReplace.replaceAll("ł", "l");
    toReplace=toReplace.replaceAll("ś", "s");
    toReplace=toReplace.replaceAll("ć", "c");
    toReplace=toReplace.replaceAll("ń", "n");
    toReplace=toReplace.replaceAll("ż", "z");
    toReplace=toReplace.replaceAll("ź", "z");
    return toReplace;
  }

  Widget ListOfStationWidget(){
    return ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, scrollDirection: Axis.vertical,
        children: listOfStationAfterSort.map((station) {
          return RaisedButton(
            color: Colors.blueGrey[700],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child:Text(station.name,style: TextStyle(fontSize: 18))
            ),
            onPressed: (){

              Station.actualStationId=station.id;
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => ShowContamination(),
                transitionDuration: Duration(seconds: 0),
              ));

            },
          );
        }).toList());
  }

  Future<bool> onBackPressed(){

  }

  Future<List<Station>> getStation() async {
    final response = await http.get('http://api.gios.gov.pl/pjp-api/rest/station/findAll');
    if (response.statusCode == 200) {
      return Station.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd ładowania');
    }
  }


}
