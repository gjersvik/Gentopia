part of gentopia;

class TextureGen{
  int _seed = 0;
  
  Hash _hash;
  
  Stopwatch total = new Stopwatch();
  Stopwatch hashtime = new Stopwatch();
  Stopwatch intertime = new Stopwatch();
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
      
    grid += inter(hash(x, y, height + 1, width +1), outHeight, outWidth);
    while(height * factor < outHeight && width * factor < outWidth){
      temp = hash( x * factor, y * factor, (height * factor) + 1, (width * factor) +1, level);
      temp /= factor;
      grid += inter(temp, outHeight, outWidth);
      divide += (1 / factor);
      factor *= 2;
      level += 1;
    }
    
    temp = hash(x * factor,y * factor, outHeight, outWidth, level);
    temp /= factor;
    grid += temp;
    divide += (1 / factor);
    
    grid /= divide;
    
    total.stop();
    return grid;
  }
  
  toString(){
    var sb = new StringBuffer();
    sb.writeln("Hash(${hashtime.elapsedMilliseconds})");
    sb.writeln("Inter(${intertime.elapsedMilliseconds})");
    sb.writeln('$mixcount mixcount');
    sb.write("TextureGen(${total.elapsedMilliseconds})");
    return sb.toString();
  }
  
  Grid hash(int hx,int hy, int height, int width, [int level = 1]){
    print('Hash x: $hx ${hx + width - 1}');
    print('Hash y: $hy ${hy + height - 1}');
    hashtime.start();
    
    var fill = new Grid.fill(height, width, (x,y) => _hash.hash('${x+hx}x${y+hy}l$level') / 0xFFFFFFFF);
    
    hashtime.stop();
    return fill;
  }
  
  Grid inter(Grid data, int newHeight, int newWidth){
    intertime.start();
    var grid = data.scaleUp(newHeight, newWidth, mix);
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