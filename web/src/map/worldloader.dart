part of gentopiamap;

class WorldLoader{
  World world = new World();
  
  WorldLoader(){
    
  }
  
  Future<String> getTile(int x, int y, int height, int width, [int outHeight = 512, int outWidth = 512]){
    var data = world.makeTexture(x, y, height, width, outHeight, outWidth);
  
    var canvas = new CanvasElement(height:outHeight,width:outWidth);
    
    var paint = canvas.context2D;
    var img = paint.createImageData(512, 512);
    var imgd = img.data;
    
    for(var i = 0; i < data.length; i += 1){
      imgd[i] = data[i];
    }
    
    paint.putImageData(img, 0, 0);
    return new Future.value(canvas.toDataUrl());
  }
}