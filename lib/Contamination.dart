
class Contamination{
  int id;
  static int idToFind;
  String name;
  Map<String,dynamic> mapa;

  Contamination({this.id,this.mapa});

  static List<Contamination> fromJson(List<dynamic> lista){

    List<Contamination> listToReturn=new List();
    for(var pom in lista){

      listToReturn.add(new Contamination(

        mapa: pom['param'],
        id: pom['id'],
      ));
    }
    return listToReturn;
  }
}