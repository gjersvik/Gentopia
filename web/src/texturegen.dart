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
    
    var grid = new Grid(outHeight,outWidth);
    var factor = 2;
    var divide = 1;
    var level = 2;
    var temp;
      
    grid.addGrid(inter(hash(new Grid(height + 1,width +1), x,y), outHeight, outWidth));
    while(height * factor < outHeight && width * factor < outWidth){
      temp = new Grid((height * factor) + 1,(width * factor) +1);
      temp = hash(temp, x * factor,y * factor, level);
      temp.divide(factor);
      grid.addGrid(inter(temp, outHeight, outWidth));
      divide += (1 / factor);
      factor *= 2;
      level += 1;
    }
    
    temp = new Grid(outHeight, outWidth);
    temp = hash(temp, x * factor,y * factor, level);
    temp.divide(factor);
    grid.addGrid(temp);
    divide += (1 / factor);
    
    grid.divide(divide);
    
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
}