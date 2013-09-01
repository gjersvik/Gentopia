part of gentopiamap;

class WorldLoader{
  String uri;
  
  SendPort worker;
  
  ReceivePort debug = new ReceivePort();
  
  WorldLoader([this.uri = 'world.dart']){
    debug.receive((message, SendPort replyTo)=> print("Worker: $message"));
    
    worker = spawnUri(uri);
    worker.send('errorPort', debug.toSendPort());
  }
  
  Future<String> getTile(int x, int y, int height, int width, [int outHeight = 512, int outWidth = 512]){
    print('WorldLoader.getTile($x:$y:$height:$width:$outHeight:$outWidth)');
    return worker.call("$x:$y:$height:$width:$outHeight:$outWidth").then((String data){
      print('WorldLoader.getTile: godt data back');
      var canvas = new CanvasElement(height:outHeight,width:outWidth);
      
      var paint = canvas.context2D;
      var img = paint.createImageData(512, 512);
      var imgd = img.data;
      
      for(var i = 0; i < data.length; i += 1){
        imgd[i] = data.codeUnits[i];
      }
      
      paint.putImageData(img, 0, 0);
      return canvas.toDataUrl();
    });
  }
}