part of gentopia;

class Prandom {
  static const int _C1 = 0xcc9e2d51;
  static const int _C2 = 0x1b873593;
  static const int _R1 = 15;
  static const int _R1_M = 32 - _R1;
  static const int _R2 = 13;
  static const int _R2_M = 32 - _R2;
  static const int _M = 5;
  static const int _N = 0xe6546b64;
  static const int _B32 = 0xffffffff;
  static const int _B8 = 0xff;
  
  int _seed = 0;
  
  Prandom(String seed, [Prandom parent]){
    if(seed != ''){
      if(parent != null){
        _seed = parent.getValue(seed);
      }else{
        _seed = getValue(seed);
      }
    }
  }
  
  int getValue(String s){
    var data = s.codeUnits;
    var length = data.length;
    var remainder = length % 4;
    var k = 0;
    var hash = _seed;
    
    for(var i = 0;i < length - 3; i += 4){
      k = ((data[i] & _B8)) |
          ((data[i + 1] & _B8) << 8) |
          ((data[i + 2] & _B8) << 16) |
          ((data[i + 3] & _B8) << 24);
      
      k = (k * _C1) & _B32;
      k = (k << _R1) | (k >> _R1_M);
      k = (k * _C2) & _B32;
      
      hash ^= k;
      hash = (hash << _R2) | (hash >> _R2_M);
      hash = (hash * _M + _N) & _B32;
    }
    
    k = 0;
    if(remainder == 3){
      k ^= (data[length - 3] & _B8) << 16;
    }
    if(remainder >= 2){
      k ^= (data[length - 2] & _B8) << 8;
    }
    if(remainder >= 1){
      k ^= (data[length - 1] & _B8);
      k = (k * _C1) & _B32;
      k = (k << _R1) | (k >> _R1_M);
      k = (k * _C2) & _B32;
      
      hash ^= k;
    }
    
    hash ^= data.length;
    hash ^= (hash >> 16);
    hash = (hash * 0x85ebca6b) & _B32;
    hash ^= (hash >> 13);
    hash = (hash * 0xc2b2ae35) & _B32;
    hash ^= (hash >> 16);
    
    return hash;
  }
}