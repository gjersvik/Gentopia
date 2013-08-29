part of gentopia;

class TextureGen{
  int _seed = 0;
  
  Hash _hash;
  
  Stopwatch total = new Stopwatch();
  Stopwatch hashtime = new Stopwatch();
  Stopwatch intertime = new Stopwatch();
  Stopwatch turbu = new Stopwatch();
  TextureGen(String seed){
    _hash = new Hash(seed);
    total = new Stopwatch();
  }
  
  Grid getTile(int x,int y, height, width,[int outHeight = 512, int outWidth = 512]){
    print('$x $y');
    total.start();
   
    var grid = new Grid(height + 1,width + 1);
    hash(grid, x, y);
    grid = inter(grid, outHeight, outWidth);
    total.stop();
    return grid;
  }
  
  toString(){
    var sb = new StringBuffer();
    sb.writeln("Hash(${hashtime.elapsedMilliseconds})");
    sb.writeln("Inter(${intertime.elapsedMilliseconds})");
    sb.writeln('$mixcount mixcount');
    sb.writeln("Turbulence(${turbu.elapsedMilliseconds})");
    sb.write("TextureGen(${total.elapsedMilliseconds})");
    return sb.toString();
  }
  
  Grid hash(Grid fill, int xfrom,int yfrom, [int level = 1]){
    print('Hash x: $xfrom ${xfrom + fill.width}');
    print('Hash y: $yfrom ${yfrom + fill.height}');
    hashtime.start();
    
    fill.fill((x,y) => _hash.hash('${x}x{$y}l$level') / 0xFFFFFFFF, xfrom, yfrom);
    
    hashtime.stop();
    return fill;
  }
  
  Grid inter(Grid data, int outHeight, int outWidth){
    intertime.start();
    var grid = new Grid(outHeight, outWidth);
    int height = data.height - 1;
    int width = data.width - 1;
    int hcell = outHeight ~/ height;
    int wcell = outWidth ~/ width;
    
    for(int x = 0; x < width; x += 1 ){
      int x2 = x + 1;
      int ix = x * wcell;
      for(int y = 0; y < height; y += 1 ){
        int y2 = y + 1;
        int iy = y * hcell;
        for(int fy = 0; fy < hcell; fy += 1 ){
          var xt = mix(data.get(x, y), data.get(x, y2), fy / hcell);
          var xb = mix(data.get(x2, y), data.get(x2, y2), fy / hcell);
          for(int fx = 0; fx < wcell; fx += 1 ){
            grid.set(ix + fx, iy + fy, mix(xt, xb, fx / wcell));
          }
        }
      }
    }
    intertime.stop();
    return grid;
  }

  var mixcount = 0;
  mix(a, b, t){
    mixcount += 1;
    t = t*t*(3 - 2*t);
    return a*(1-t) + b*t;
  }

  Float64List turbulence(int x, int y, int zoom){
    print('$x $y $zoom');
    turbu.start();
    var value = [];
    var izoom = zoom;
    
    double truex = 0.0;
    double truey = 0.0;
    
    
    while(izoom >= 2){
      var list = hash(x * izoom ,y * izoom,izoom,(512 ~/ izoom) +1);
      value.add(inter(list,izoom));
      izoom = izoom ~/ 2;
    }
    value.add(hash(x,y,1,512));
    
    var div = 0;
    for(var j = 0; j < value.length; j += 1){
      div += 1 / (j + 1);
    }
    
    for(var i = 0; i < 512*512; i+=1){
      var sum = 0;
      for(var j = 0; j < value.length; j += 1){
        sum += value[j][i] / (j + 1);
      }
      sum /= div;
      value[0][i] = sum;
    }
    turbu.stop();
    return value.first;
  }
}