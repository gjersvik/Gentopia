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
  
  double x = 0.0;
  double y = 0.0;
  num height;
  num width;
  bool resized = true;
  bool moved = true;
  
  WorldLoader load = new WorldLoader();
  List<Tile> list = [];
  
  Maper(this.elem){
    window.onResize.listen((_) => resized = true);
    window.onClick.listen(( e ){
      x -= (e.page.x - width / 2) / 512;
      y -= (e.page.y - height / 2) / 512;
      moved = true;
    });
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
      num x = this.x + width / 2 / 512;
      num y = this.y + height / 2 / 512;
      
      list.forEach((t){
        int lx = ((x + t.x) * 512).toInt();
        int ly = ((y + t.y) * 512).toInt();
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