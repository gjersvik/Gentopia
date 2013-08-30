library gentopia;

import 'dart:html';
import 'dart:typed_data';

part 'src/hash.dart';
part 'src/texturegen.dart';
part 'src/grid.dart';

class Maper{
  CanvasElement c;
  CanvasRenderingContext2D p;
  ImageData img;
  ImageData img1;
  ImageData img2;
  ImageData img3;

  TextureGen gen = new TextureGen('Ole Martin');
  
  Maper(this.c){
    p = c.context2D;
    img = p.createImageData(512, 512);
    img1 = p.createImageData(512, 512);
    img2 = p.createImageData(512, 512);
    img3 = p.createImageData(512, 512);
  }
  
  start([_]) {
    Stopwatch total = new Stopwatch()..start();
    
    gridToImage(gen.getTile(0, 0, 16, 16), img);
    p.putImageData(img, 0, 0);
    gridToImage(gen.getTile(16, 0, 16, 16), img1);
    p.putImageData(img1, 512, 0);
    gridToImage(gen.getTile(0, 16,16,16), img2);
    p.putImageData(img2, 0, 512);
    gridToImage(gen.getTile(16, 16, 16,16), img3);
    p.putImageData(img3, 512, 512);
    
    print(gen);
    print("Total(${total.elapsedMilliseconds})");
  }
  
  gridToImage(Grid pic,img){
    var picd = pic.getData();
    var imgd = img.data;
    for(var i = 0; i < picd.length; i += 1){
      int imgi = i * 4;
      int h = (picd[i] * 255).round();
      imgd[imgi] = h;
      imgd[imgi + 1] = h;
      imgd[imgi + 2] = h;
      imgd[imgi + 3] = 255;
    }
  }
}

void main() {
  var text = new Maper(query("#canvas"));
  text.start();
}