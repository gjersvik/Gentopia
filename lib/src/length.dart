part of gentopia;

class Length{
  final int mm;
  
  const Length(this.mm);
  factory Length.inMeters(num m) => new Length((m * 1000).toInt());
  factory Length.inKilometers(num km) => new Length((m * 1000).toInt());
  
  double get m => mm / 1000;
  double get km => mm / 1000000;
  
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

