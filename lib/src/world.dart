part of gentopia;

class World{
  TextureGen gen = new TextureGen('Ole Martin');
  ColorGen cgen = new ColorGen();
  
  Uint8List makeTexture(int x, int y, int height, int width, [int outHeight = 512 , int outWidth = 512]){
    Grid grid = gen.getTile(x, y, height, width, outHeight, outWidth);
    
    Uint8List data = new Uint8List(outHeight * outWidth * 4);
    var tile = grid.getData();
    
    for(var i = 0; i < tile.length; i += 1){
      var c = cgen.getColor(tile[i]);
      var d = i * 4;
      
      data[d] = c.red;
      data[d + 1] = c.green;
      data[d + 2] = c.blue;
      data[d + 3] = c.alfa;
    }
    return  data;
  }
}