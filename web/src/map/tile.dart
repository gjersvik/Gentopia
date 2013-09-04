part of gentopiamap;

class Tile{
  final Rect rect;
  final ImageElement img;
  
  const Tile(this.rect, this.img);
  
  put(Point p){
    p = rect.topLeft - p;
    p *= 512;
    p = p.floor();
    img.style.left = '${p.x}px';
    img.style.top = '${p.y}px';
  }
}