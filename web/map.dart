library gentopiamap;

import 'dart:async';
import 'dart:html';
import 'dart:isolate';

part 'src/map/worldloader.dart';

class Maper{
  Element elem;
  
  WorldLoader load = new WorldLoader();
  
  Maper(this.elem){
    
  }
  
  start() {
    load.getTile(-16, -16, 16, 16).then((data){
      ImageElement img = new ImageElement(src:data);
      elem.append(img);
    });

    load.getTile(0, -16, 16, 16).then((data){
      ImageElement img = new ImageElement(src:data);
      img.style.left = '512px';
      elem.append(img);
    });
    

    load.getTile(-16, 0, 16, 16).then((data){
      ImageElement img = new ImageElement(src:data);
      img.style.top = '512px';
      elem.append(img);
    });
    

    load.getTile(0, 0, 16, 16).then((data){
      ImageElement img = new ImageElement(src:data);
      img.style.left = '512px';
      img.style.top = '512px';
      elem.append(img);
    });
  }
  
}

void main() {
  var map = new Maper(query("#map"));
  map.start();
}