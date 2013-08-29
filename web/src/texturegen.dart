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
  
  Grid getTile(int x,int y,int zoom){
    print('$x $y');
    total.start();
   
    var grid = new Grid(512,512);
    hash(grid, x, y);
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
  
  Float64List inter(Float64List data, int zoom){
    intertime.start();
    var list = new Float64List(512*512);
    var size = 512 ~/ zoom;
    print('inter $zoom $size');
    for(int x = 0; x < size; x += 1 ){
      int x2 = x + 1;
      int ix = x * zoom;
      for(int y = 0; y < size; y += 1 ){
        int y2 = y + 1;
        int iy = y * zoom;
        for(int fy = 0; fy < zoom; fy += 1 ){
          var xt = mix(data[(y * (size +1)) + x],data[(y2 * (size +1)) + x],1-(fy / zoom));
          var xb = mix(data[(y * (size +1)) + x2],data[(y2 * (size +1)) + x2],1-(fy / zoom));
          for(int fx = 0; fx < zoom; fx += 1 ){
            list[((iy + fy) * 512) + ix + fx] = mix(xt, xb, 1-(fx / zoom));
          }
        }
      }
    }
    intertime.stop();
    return list;
  }

  var mixcount = 0;
  mix(a, b, t){
    mixcount += 1;
    t = t*t*(3 - 2*t);
    return a*t + b*(1-t);
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