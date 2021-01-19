import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jakosc_powietrza/LoadingScreen.dart';
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
                  for(Station station in listOfStationFirst){
                    if(station.name.contains(val)){
                      newList.add(station);
                    }
                  }
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

  Widget ListOfStationWidget(){
    return ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, scrollDirection: Axis.vertical,
        children: listOfStationAfterSort.map((station) {
          return RaisedButton(
            child: Text(station.name),
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
