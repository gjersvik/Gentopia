part of gentopiamap;

class Tile{
  final Rectangle rect;
  final ImageElement img;
  
  const Tile(this.rect, this.img);
  
  put(Point p){
    p = rect.topLeft - p;
    p *= 512;
    p = new Point(p.x.floor(),p.y.floor());
    img.style.left = '${p.x}px';
    img.style.top = '${p.y}px';
  }
}