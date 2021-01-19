class Station{
  String name;
  int id;

  Station({this.name, this.id});

  static List<Station> fromJson(List<dynamic> lista){
    List<Station> listToReturn=new List();
    for(var pom in lista){
      listToReturn.add(new Station(
        name: pom['stationName'],
        id: pom['id'],
      ));
    }
    return listToReturn;
  }
}