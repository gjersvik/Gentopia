part of gentopia;

class TextureGen{
  int _seed = 0;
  
  Prandom _top;
  Map<int,Prandom> _levels = {};
  
  
  TextureGen(String seed){
    _top = new Prandom(seed);
  }
  
  Grid getTile(int x,int y, height, width,[int outHeight = 512, int outWidth = 512]){
    
    var grid = new Grid(outHeight,outWidth);
    var factor = 2;
    var divide = 1;
    var level = 2;
    var temp;
      
    grid += hash(x, y, height + 1, width +1).scaleUp(outHeight, outWidth, mix);
    while(height * factor < outHeight && width * factor < outWidth){
      temp = hash( x * factor, y * factor, (height * factor) + 1, (width * factor) +1, level);
      temp /= factor;
      grid += temp.scaleUp(outHeight, outWidth, mix);
      divide += (1 / factor);
      factor *= 2;
      level += 1;
    }
    
    temp = hash(x * factor,y * factor, outHeight, outWidth, level);
    temp /= factor;
    grid += temp;
    divide += (1 / factor);
    
    grid /= divide;
    
    return grid;
  }
  
  Grid hash(int hx,int hy, int height, int width, [int level = 1]){
    var ydiff = hy % 32;
    var xdiff = hx % 32;
    var fill = new Grid(height, width);
    
    for(var y = 0; y - ydiff < height; y += 32){
      for(var x = 0; x - xdiff < width; x += 32){
        fill.put(x - xdiff , y - ydiff, hashCell(hx + x - xdiff,hy + y - ydiff, level));
      }
    }
    return fill;
  }
  
  Grid hashCell(int x,int y,int level){
    if(!_levels.containsKey(level)){
      _levels[level] = new Prandom("$level",_top);
    }
    var rand = new Random(_levels[level].getValue('${x}x${y}'));
    return new Grid.fill(32, 32, (x, y) => rand.nextDouble());
  }


  mix(a, b, t){
    t = t*t*(3 - 2*t);
    return a*(1-t) + b*t;
  }
}