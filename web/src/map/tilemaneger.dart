part of gentopiamap;

class TileManeger{
  
  WorldLoader _world;
  Map<Point,Tile> _cache = new Map();
  TileManeger(this._world);
  
  List<Tile> getTiles(Rectangle rect){
    List list = [];
    var topLeft = new Point(rect.topLeft.x.floor(),rect.topLeft.y.floor());
    var bottomRight = new Point(rect.bottomRight.x.ceil(),rect.bottomRight.y.ceil());
    var r = new Rectangle.fromPoints(topLeft, bottomRight);
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
    Rectangle r = new Rectangle(p.x, p.y, 1, 1);
    Tile tile = new Tile(r, new ImageElement());
    _cache[p] = tile;
    
    _world.getTile(r.left, r.top, r.height, r.width).then((data){
      tile.img.src = data;
    });
    
    return tile;
  }
}