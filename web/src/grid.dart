part of gentopia;

class Grid{
  final int height;
  final int width;
  Float64List _data;
  
  Grid(this.height,this.width){
    _data = new Float64List(this.height*width);
  }
  
  addGrid(Grid v){
    var vdata = v._data;
    for(var i = 0; i < _data.length; i += 1){
      _data[i] += vdata[i];
    }
  }
  
  divide(num v){
    for(var i = 0; i < _data.length; i += 1){
      _data[i] /= v;
    }
  }
  
  get(int x,int y) => _data[(y*width) + x];
  set(int x,int y, double value) =>  _data[(y*width) + x] = value;
  
  Float64List getData() => _data;
  
  fill(double generate(int x, int y), [int fromx = 0, int fromy = 0]){
    for(var y = 0; y < height; y += 1){
      var truey = y + fromy;
      var ywidth = y * width;
      for(var x = 0; x < width; x += 1){
        truey = y + fromy;
        _data[ywidth + x] = generate(truey,x + fromx);
      }
    }
  }
}