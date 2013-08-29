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
  
  Float64List getTile(int x,int y,int zoom){
    print('$x $y');
    total.start();
    
    var list = turbulence(x, y, zoom);
    total.stop();
    return list;
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
  
  Float64List hash(int x,int y,[int zoom = 1, var size = 513]){
    print('Hash first: $x $y');
    hashtime.start();
    var list = new Float64List(size*size);
    zoom = 512 ~/ zoom;
    var xfrom = x;
    var yfrom = y;
    var truex = 0;
    var truey = 0;
    
    for(var x = 0; x < size; x += 1){
      truex = x + xfrom;
      for(var y = 0; y < size; y += 1){
        truey = y + yfrom;
        list[((y * size) + x)] = _hash.hash('${truex}x{$truey}x$zoom') / 0xFFFFFFFF;
      }
    }
    print('Hash last:$truex $truey');
    
    hashtime.stop();
    return list;
  }
  
  List<double> hashline(String data){
    var rand = new Random(_hash.hash(data));
    return new List.generate(512, (_)=>rand.nextDouble(), growable: true);
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