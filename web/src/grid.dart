part of gentopia;

class Grid{
  final int height;
  final int width;
  final Float64List _data;
  
  factory Grid(height,width) => new Grid._internal(height,width,new Float64List(height*width));
  factory Grid.fill(height,width, double generate(int x, int y)){
    var data = new Float64List(height*width);
    for(var y = 0; y < height; y += 1){
      var ywidth = y * width;
      for(var x = 0; x < width; x += 1){
        data[ywidth + x] = generate(x,y);
      }
    }
    return new Grid._internal(height,width,data);
  }
  
  Grid operator +(v){
    var data = new Float64List(height*width);
    if(v is Grid){
      var vdata = v._data;
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] + vdata[i];
      }
    }else{
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] + v;
      }
    }
    return new Grid._internal(height,width,data);
  }
  
  Grid operator -(v){
    var data = new Float64List(height*width);
    if(v is Grid){
      var vdata = v._data;
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] - vdata[i];
      }
    }else{
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] - v;
      }
    }
    return new Grid._internal(height,width,data);
  }
  
  Grid operator *(v){
    var data = new Float64List(height*width);
    if(v is Grid){
      var vdata = v._data;
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] * vdata[i];
      }
    }else{
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] * v;
      }
    }
    return new Grid._internal(height,width,data);
  }
  
  Grid operator /(v){
    var data = new Float64List(height*width);
    if(v is Grid){
      var vdata = v._data;
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] / vdata[i];
      }
    }else{
      for(var i = 0; i < _data.length; i += 1){
        data[i] = _data[i] / v;
      }
    }
    return new Grid._internal(height,width,data);
  }
  
  Grid scaleUp(int newHeight,int newWidth,double mix(double a, double b, double t)){
    var data = new Float64List(newHeight * newWidth);
    int lheight = height - 1;
    int lwidth = width - 1;
    int hcell = newHeight ~/ lheight;
    int wcell = newWidth ~/ lwidth;
    
    for(int x = 0; x < lwidth; x += 1 ){
      int x2 = x + 1;
      int ix = x * wcell;
      for(int y = 0; y < lheight; y += 1 ){
        int y2 = y + 1;
        int iy = y * hcell;
        for(int fy = 0; fy < hcell; fy += 1 ){
          var ywidth = (iy + fy) * newWidth;
          var xt = mix(get(x, y), get(x, y2), fy / hcell);
          var xb = mix(get(x2, y), get(x2, y2), fy / hcell);
          for(int fx = 0; fx < wcell; fx += 1 ){
            data[ywidth + ix + fx] = mix(xt, xb, fx / wcell);
          }
        }
      }
    }
    return new Grid._internal(newHeight, newWidth, data);
  }
  
  get(int x,int y) => _data[(y*width) + x];
  set(int x,int y, double value) =>  _data[(y*width) + x] = value;
  
  Float64List getData() => _data;
  
  Grid._internal(this.height,this.width,this._data);
}