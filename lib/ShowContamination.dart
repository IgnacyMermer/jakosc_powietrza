import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jakosc_powietrza/Contamination.dart';
import 'package:jakosc_powietrza/Data.dart';

import 'LoadingScreen.dart';
import 'Station.dart';
class ShowContamination extends StatefulWidget {
  @override
  _ShowContaminationState createState() => _ShowContaminationState();
}

class _ShowContaminationState extends State<ShowContamination> {

  List<Contamination> listOfContaminationFirst = new List();
  List<Data> listOfThisContaminationFirst = new List();
  bool isLoaded=false,isLoadedThis=false;
  String searchTerm='';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(

        body: Container(
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Text("Dane pochodzą z Głównego Inspektoratu Ochrony Środowiska(GIOŚ)",textAlign: TextAlign.center,),
                  SizedBox(height: 15),
                  !isLoaded?FutureBuilder<List<Contamination>>(
                      future:getContaminations(),
                      builder: (context, snapshot){

                        if(snapshot.hasData){
                          isLoaded=true;
                          listOfContaminationFirst=snapshot.data;

                          return ListOfContaminationWidget();

                        }
                        else{
                          return LoadingScreen();
                        }
                      }
                  ):ListOfContaminationWidget(),
                ],
              )
          ),
        ),
      ),
    );
  }


  Widget alertThisContamination(BuildContext context){
    return new AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(

          children: <Widget>[
            Text('Zanieczyszczenia w zależności od godziny',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22)),

            SizedBox(height: 20),

            SizedBox(
              height: 500,
              child: FutureBuilder<List<Data>>(
                future:getThisContamination(),
                builder: (context, snapshot){

                  if(snapshot.hasData){
                    isLoadedThis=true;
                    listOfThisContaminationFirst=snapshot.data;

                    return ListOfThisContaminationWidget();

                  }
                  else{
                    return LoadingScreen();
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget ListOfContaminationWidget(){
    return ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, scrollDirection: Axis.vertical,
        children: listOfContaminationFirst.map((contamination) {
          return RaisedButton(
            child: Text(contamination.mapa['paramName']),
            onPressed: (){
              Contamination.idToFind=contamination.id;
              showDialog(context: context, builder: (BuildContext context)=>alertThisContamination(context));


            },
          );
        }).toList());
  }

  Widget ListOfThisContaminationWidget(){
    return ListView(
        children: listOfThisContaminationFirst.map((contamination) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child:Container(
              color:Colors.grey[500],
              child:Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3),
                child: Text(contamination.hour.substring(0,contamination.hour.length-3)+"\t"+contamination.value+
                    (contamination.value!='Nie podana'?"  μg/m\u00B3":""),
                  textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18)),
              )
            )
          );
        }).toList());
  }


  Future<List<Contamination>> getContaminations() async{
    final response = await http.get('http://api.gios.gov.pl/pjp-api/rest/station/sensors/${Station.actualStationId.toString()}');
    if (response.statusCode == 200) {
      return Contamination.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd ładowania');
    }
  }

  Future<List<Data>> getThisContamination() async{
    final response = await http.get('http://api.gios.gov.pl/pjp-api/rest/data/getData/${Contamination.idToFind}');
    print(response.statusCode);
    if (response.statusCode == 200) {
      String str = response.body.split("[")[1];
      List<String> tab = str.split("},");
      return Data.fromTab(tab);
    } else {
      throw Exception('Błąd ładowania');
    }
  }

  Future<bool> onBackPressed(){
    Navigator.pop(context);
  }
}
