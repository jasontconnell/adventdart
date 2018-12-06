import "dart:io";
import "dart:collection";
const input = "01.txt";

void main(){
  var ints = [];
  new File(input).readAsString().then((String contents){
    var vals = contents.split("\n");
    for (var i in vals){
      int val = int.parse(i);
      ints.add(val);
    }

    var valmap = new HashMap<int, bool>();
    valmap.putIfAbsent(0, () => true);
    int value = 0;
    int twice = null;
    while (twice == null){
      for (int i in ints){
        value += i;

        if (valmap.containsKey(value) && twice == null){
          twice = value;
        }
        valmap.putIfAbsent(value, () => true);
      }
    }
    print(value);
    print(twice);
  });
}