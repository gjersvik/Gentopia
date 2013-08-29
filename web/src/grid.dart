part of gentopia;

class Grid{
  final int height;
  final int width;
  Float64List data;
  
  Grid(this.height,this.width){
    data = new Float64List(this.height*width);
  }
  
  get(int x,int y) => data[(y*width) + x];
  set(int x,int y, double value) =>  data[(y*width) + x] = value;
  
  fill(double generate(int x, int y), [int fromx = 0, int fromy = 0]){
    for(var y = 0; y < height; y += 1){
      var truey = y + fromy;
      var ywidth = y * width;
      for(var x = 0; x < width; x += 1){
        truey = y + fromy;
        data[ywidth + x] = generate(truey,x + fromx);
      }
    }
  }
}