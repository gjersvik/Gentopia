library gentopiamap;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:gentopia/gentopia.dart';

part 'src/map/tile.dart';
part 'src/map/tilemaneger.dart';
part 'src/map/worldloader.dart';

class Maper{
  Element elem;
  
  Rectangle client = new Rectangle(0,0,0,0);  
  num height;
  num width;
  bool resized = true;
  bool moved = true;
  
  WorldLoader load = new WorldLoader();
  TileManeger tiles;
  
  List<Tile> _oldList = [];
  
  Maper(this.elem){
    window.onResize.listen((_) => resized = true);
    window.onClick.listen(( e ){
      var p = e.page * (1/512);
      p -= new Point(client.width / 2, client.height / 2);
      p = client.topLeft + p;
      client = new Rectangle(p.x, p.y, client.width, client.height);
      moved = true;
    });
    
    tiles = new TileManeger(load);
  }
  
  start() => updatePos();
  
  updatePos( [_] ){
    if(resized){
      height = elem.borderEdge.height;
      width = elem.borderEdge.width;
      client = new Rectangle(client.left, client.top, width / 512, height / 512);
      resized = false;
      moved = true;
    }
    
    if(moved){
      _oldList.forEach((t) => t.img.remove());
      _oldList = tiles.getTiles(client);
      
      _oldList.forEach((t){
        elem.append(t.img);
        t.put(client.topLeft);
      });
      moved = false;
    }
    window.animationFrame.then(updatePos);
  }
  
}

void main() {
  var map = new Maper(querySelector("#map"));
  map.start();
}