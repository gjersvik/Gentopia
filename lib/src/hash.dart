part of gentopia;

class Hash{
  static const C1 = 0xcc9e2d51;
  static const C2 = 0x1b873593;
  static const R1 = 15;
  static const R1_M = 32 - R1;
  static const R2 = 13;
  static const R2_M = 32 - R2;
  static const M = 5;
  static const N = 0xe6546b64;
  static const B32 = 0xffffffff;
  static const B8 = 0xff;
  
  int _seed = 0;
  
  Hash(String seed){
    _seed = hash(seed);
  }
  
  int hash(String s){
    var data = s.codeUnits;
    var length = data.length;
    var remainder = length % 4;
    var k = 0;
    var hash = _seed;
    
    for(var i = 0;i < length - 3; i += 4){
      k = ((data[i] & B8)) |
          ((data[i + 1] & B8) << 8) |
          ((data[i + 2] & B8) << 16) |
          ((data[i + 3] & B8) << 24);
      
      k = (k * C1) & B32;
      k = (k << R1) | (k >> R1_M);
      k = (k * C2) & B32;
      
      hash ^= k;
      hash = (hash << R2) | (hash >> R2_M);
      hash = (hash * M + N) & B32;
    }
    k = 0;
    if(remainder == 3){
      k ^= (data[length - 3] & B8) << 16;
    }
    if(remainder >= 2){
      k ^= (data[length - 2] & B8) << 8;
    }
    if(remainder >= 1){
      k ^= (data[length - 1] & B8);
      k = (k * C1) & B32;
      k = (k << R1) | (k >> R1_M);
      k = (k * C2) & B32;
      
      hash ^= k;
    }
    
    hash ^= data.length;
    hash ^= (hash >> 16);
    hash = (hash * 0x85ebca6b) & B32;
    hash ^= (hash >> 13);
    hash = (hash * 0xc2b2ae35) & B32;
    hash ^= (hash >> 16);
    
    return hash;
  }
}