part of gentopiamap;

class TileManeger{
  
  WorldLoader _world;
  Map<Point,Tile> _cache = new Map();
  TileManeger(this._world);
  
  List<Tile> getTiles(Rect rect){
    List list = [];
    var r = new Rect.fromPoints(rect.topLeft.floor(), rect.bottomRight.ceil());
    for(var y = r.top; y <= r.bottom; y += 1 ){
      for(var x = r.left; x <= r.right; x += 1 ){
        list.add(getTile(new Point(x,y)));
      }
    }
    return list;
  }
  
  Tile getTile(Point p){
    if(_cache.containsKey(p)){
      return _cache[p];
    }
    Rect r = new Rect(p.x, p.y, 1, 1);
    Tile tile = new Tile(r, new ImageElement());
    _cache[p] = tile;
    
    _world.getTile(r.left, r.top, r.height, r.width).then((data){
      tile.img.src = data;
    });
    
    return tile;
  }
}