part of gentopiaworld;

class ColorGen {
  
  Map _points = new Map();
  ColorGen(){
    addPoint(0.0, new Color(6, 48, 168));
    addPoint(0.25, new Color(6, 48, 168));
    addPoint(0.45, new Color(192, 218, 255));
    addPoint(0.475, new Color(173, 242, 138));
    addPoint(0.5, new Color(0, 200, 22));
    addPoint(0.7, new Color(0, 150, 18));
    addPoint(0.89, new Color(202, 203, 201));
    addPoint(0.9, new Color(236, 234, 255));
    addPoint(1.0, new Color(255,255,255));
  }
  
  addPoint(double point, Color color) => _points[point] = color;
  
  Color getColor(double value){
    var prev = 0.0;
    var prevColor = _points[0.0];
    var next = 1.0;
    var nextColor = _points[1.0];
    
    _points.forEach((v, c){
      if(v <= value){
        if(v > prev){
          prev = v;
          prevColor = c;
        }
      }else{
        if(v < next){
          next = v;
          nextColor = c;
        }
      }
    });
    
    value -= prev;
    
    return mix(prevColor, nextColor, value / (next - prev));
  }
  
  Color mix(Color from, Color to, double t){
    return new Color(
        (from.red * (1-t) + to.red * t).round(),
        (from.green * (1-t) + to.green * t).round(),
        (from.blue * (1-t) + to.blue * t).round(),
        (from.alfa * (1-t) + to.alfa * t).round()
    );
  }
}

class Color{
  final int red;
  final int green;
  final int blue;
  final int alfa;
  
  Color(this.red, this.green, this.blue, [this.alfa = 255]);
}