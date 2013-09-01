library gentopiaworld;

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

part 'src/world/color.dart';
part 'src/world/grid.dart';
part 'src/world/hash.dart';
part 'src/world/texturegen.dart';

SendPort debug;

void print(Object obj){
  debug.send(obj.toString());
}

dynamic gard(dynamic call()){
  try{
    return call();
  }catch(e){
    print(e);
    if(e is Error){
      print((e as Error).stackTrace);
    }
    port.close();
  }
}

class World{
  TextureGen gen = new TextureGen('Ole Martin');
  ColorGen cgen = new ColorGen();
  
  start(){
    print('World.start');
    port.receive((String order, SendPort replyTo){
      print('World.receive($order)');
      replyTo.send(makeTexture(order));
    });
  }
  
  String makeTexture(String order){
    print("Start:$order");
    var args = order.split(':');
    int x = int.parse(args[0]);
    int y = int.parse(args[1]);
    int height = int.parse(args[2]);
    int width = int.parse(args[3]);
    int outHeight = int.parse(args[4]);
    int outWidth = int.parse(args[5]);
    
    Grid grid = gen.getTile(x, y, height, width, outHeight, outWidth);
    List<int> data = [];
    var tile = grid.getData();
    for(var i = 0; i < tile.length; i += 1){
      var c = cgen.getColor(tile[i]);
      data.add(c.red);
      data.add(c.green);
      data.add(c.blue);
      data.add(c.alfa);
    }
    print("Done:$order");
    return new String.fromCharCodes(data);
  }
}

main(){
  var world = new World();
  
  port.receive((String order, SendPort replyTo){
    if(order == 'errorPort'){
      debug = replyTo;
      gard(world.start);
    }else{
      gard(()=>replyTo.send(world.makeTexture(order)));
    }
    debug.send("World.receive($order)");
  });
}