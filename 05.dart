import "dart:io";
import "dart:core";
const input = "05.txt";

void main(){
    new File(input).readAsString().then((String contents){
      var r = reduce(contents);

      print(r);
      print(r.length);

      var m = new Map<String, bool>();
      for (int i = 0; i < contents.length; i++){
        m.putIfAbsent(contents[i].toLowerCase(), () => true);
      }

      int min = r.length;
      String c = "";
      for (var k in m.keys){
        String test = contents.replaceAll(k, "").replaceAll(k.toUpperCase(), "");
        String rtest = reduce(test);
        if (rtest.length < min){
          min = rtest.length;
          c = k;
        }
      }

      print("Most impactful removal = " + c + " with length " + min.toString());
    });
}

String reduce(String x) {
  if (x.length < 2) return x;

  if (x.length == 2){
    if (isMatch(x[0], x[1]))
      return "";
    else return x;
  }

  String reduced = x;
  for (int i = 0; i < reduced.length-1; i++){
    if (isMatch(reduced[i], reduced[i+1])){
      reduced = reduced.substring(0, i) + reduced.substring(i+2);
      
      i = -1;
    }
  }

  return reduced;
}

bool isMatch(String x, String y){
  bool same = x.toLowerCase() == y.toLowerCase();
  return same && (isLower(x) && !isLower(y) || isLower(y) && !isLower(x));
}

bool isLower(String x){
  return x.codeUnits[0] >= 65 && x.codeUnits[0] <= 90;
}