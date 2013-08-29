library gentopia;

import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

part 'src/hash.dart';
part 'src/texturegen.dart';

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
    
    picToImage(gen.getTile(0, 0, 32), img);
    p.putImageData(img, 0, 0);
    picToImage(gen.getTile(512, 0, 32), img1);
    p.putImageData(img1, 512, 0);
    picToImage(gen.getTile(0, 16,32), img2);
    p.putImageData(img2, 0, 512);
    picToImage(gen.getTile(16, 16, 32), img3);
    p.putImageData(img3, 512, 512);
    
    print(gen);
    print("Total(${total.elapsedMilliseconds})");
  }
  
  picToImage(pic,img){
    for(var i = 0; i < pic.length; i += 1){
      int imgi = i * 4;
      int h = (pic[i] * 255).round();
      img.data[imgi] = h;
      img.data[imgi + 1] = h;
      img.data[imgi + 2] = h;
      img.data[imgi + 3] = 255;
    }
  }
}

void main() {
  var text = new Maper(query("#canvas"));
  text.start();
}