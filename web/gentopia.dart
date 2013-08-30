library gentopia;

import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

part 'src/color.dart';
part 'src/hash.dart';
part 'src/texturegen.dart';
part 'src/grid.dart';

class Maper{
  Element elem;
  
  ColorGen cgen = new ColorGen();
  CanvasElement c = new CanvasElement(height:512,width:512);
  TextureGen gen = new TextureGen('Ole Martin');
  
  Maper(this.elem){
    
  }
  
  start([_]) {
    Stopwatch total = new Stopwatch()..start();
    
    String data = gridToDataUrl(gen.getTile(0, 0, 16, 16));
    ImageElement img = new ImageElement(src:data);
    elem.append(img);
    
    print(gen);
    print("Total(${total.elapsedMilliseconds})");
  }
  
  String gridToDataUrl(Grid pic){
    var paint = c.context2D;
    var img = paint.createImageData(512, 512);
    var picd = pic.getData();
    var imgd = img.data;
    
    for(var i = 0; i < picd.length; i += 1){
      int imgi = i * 4;
      Color c = cgen.getColor(picd[i]);
      imgd[imgi] = c.red;
      imgd[imgi + 1] = c.green;
      imgd[imgi + 2] = c.blue;
      imgd[imgi + 3] = c.alfa;
    }
    
    paint.putImageData(img, 0, 0);
    return c.toDataUrl();
  }
}

void main() {
  var map = new Maper(query("#map"));
  map.start();
}