
class Data{
  String value,hour;
  Data({this.value,this.hour});

  static List<Data> fromTab(List<String> lista){
    List<Data> listToReturn=new List();
    for(String pom in lista){

      String myHour = pom.split("\",")[0].substring(14);
      String myValue = pom.split("value")[1].substring(2).split("}")[0];

      if(myValue=='null'){
        myValue="Nie podana";
      }


      listToReturn.add(new Data(
        hour: myHour,
        value: myValue,
      ));
    }

    return listToReturn;
  }


}