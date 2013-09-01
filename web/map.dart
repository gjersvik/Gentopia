library gentopiamap;

import 'dart:async';
import 'dart:html';
import 'dart:isolate';

part 'src/map/worldloader.dart';

class Tile{
  final int x;
  final int y;
  final ImageElement img;
  
  Tile(this.x, this.y, this.img);
  put(int x,int y){
    img.style.left = '${x}px';
    img.style.top = '${y}px';
  }
}

class Maper{
  Element elem;
  
  num height;
  num width;
  bool resized = true;
  bool moved = true;
  
  WorldLoader load = new WorldLoader();
  List<Tile> list = [];
  
  Maper(this.elem){
    window.onResize.listen((_) => resized = true);
  }
  
  start() {
    list.add(getTile(-1,-1));
    list.add(getTile(-0,-1));
    list.add(getTile(-1,0));
    list.add(getTile(0,0));
    
    updatePos();
  }
  
  Tile getTile(int x, int y){
    Tile tile = new Tile(x,y,new ImageElement());
    elem.append(tile.img);
    load.getTile(x, y, 1, 1).then((data){
      tile.img.src = data;
    });
    return tile;
  }
  
  updatePos( [_] ){
    if(resized){
      height = elem.borderEdge.height;
      width = elem.borderEdge.width;
      resized = false;
      moved = true;
    }
    
    if(moved){
      num x = 0 + elem.borderEdge.width / 2;
      num y = 0 + elem.borderEdge.height / 2;
      
      list.forEach((t){
        int lx = (x + t.x * 512).toInt();
        int ly = (y + t.y * 512).toInt();
        t.put(lx, ly);
      });
      moved = false;
    }
    window.animationFrame.then(updatePos);
  }
  
}

void main() {
  var map = new Maper(query("#map"));
  map.start();
}