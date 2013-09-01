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
  
  start([_]) {
    load.getTile(0, 0, 16, 16).then((data){
      ImageElement img = new ImageElement(src:data);
      elem.append(img);
    });
  }
  
}

void main() {
  var map = new Maper(query("#map"));
  map.start();
}