import "dart:io";
import "dart:core";
const input = "02.txt";

void main(){
  
  new File(input).readAsString().then((String contents){
    var vals = contents.split("\n");
    var list = new List<String>();
    int twoCount = 0;
    int threeCount = 0;
    for (var i in vals){
      list.add(i);
      int x= twoOrThree(i);
      if (x == 0) continue;

      if (x > 3) {
        twoCount++;
        threeCount++;
      }
      else if (x == 2) twoCount ++;
      else threeCount++;
    }

    print(twoCount * threeCount);

    var s = findMatches(list);
    print(s);
  });
}

int twoOrThree(String line){
  Map<int, int> m = new Map<int, int>();
  for (var c in line.runes){
    m.update(c, (v) => v + 1, ifAbsent: () => 1);
  }
  
  Map<int,int> m2 = new Map<int,int>();
  m.values.forEach((v) => m2.update(v, (v) => v+1, ifAbsent: () => 1 ));
  if (m2.containsKey(3) && m2.containsKey(2)) return 5;
  if (m2.containsKey(3)) return 3;
  if (m2.containsKey(2)) return 2;
  return 0;
}

String findMatches(List<String> list){
  for (var line in list){
    var match = findMatch(list, line);
    if (match != null){
      return match + "\n" + line;
    }
  }
  return "";
}

String findMatch(List<String> list, String line){
  for (var test in list){
    if (test == line) continue;

    if (numdiffs(test, line) == 1) return test;
  }
  return null;
}

int numdiffs(String s1, String s2){
  if (s1.length != s2.length) return -1;
  int diffs = 0;
  for (int i = 0; i < s1.length; i++) {
    if (s1[i] != s2[i]) diffs++;
  }
  return diffs;
}