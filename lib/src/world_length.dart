part of gentopia;

class WorldLength{
  int mm = 0;
  
  double get cm => mm / 10;
  set cm (num cm) => mm = (cm * 10).toInt();
  
  double get m => mm / 1000;
  set m (num m) => mm = (m * 1000).toInt();
  
  double get km => mm / 1000000;
  set km (num km) => mm = (m * 1000000).toInt();
  
  String toString(){
    if(mm < 10000 && mm > -10000){
      return '$mm mm';
    }
    
    if(mm < 10000000 && mm > -10000000){
      return '${m.toStringAsFixed(3)} m';
    }
    return '${km.toStringAsFixed(3)} km';
  }
}

