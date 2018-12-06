import "dart:io";
import "dart:core";
const input = "03.txt";

class Patch {

  String id;
  int top;
  int left;
  int w;
  int h;

  int ovr = 0;

  Patch(String id, int left, int top, int w, int h){
    this.id = id;
    this.top = top;
    this.left = left;
    this.w = w;
    this.h = h;
  }

  String toString() {
    return "#" + this.id + " @ " + this.left.toString() + "," + this.top.toString() + ": " + this.w.toString() + "x" + this.h.toString();
  }
}

class Inch {
  int x;
  int y;
  List<Patch> patches;

  Inch(int x, int y){
    this.x = x;
    this.y = y;
    this.patches = new List<Patch>();
  }
}

class Quilt {
  int w;
  int h;
  int ovr = 0;
  List<List<Inch>> inches;

  Quilt(int w, int h){
    this.w = w;
    this.h = h;
    inches = new List<List<Inch>>(w);

    for (int i = 0; i < w; i++){
      inches[i] = new List<Inch>(h);
      for (int j = 0; j < h; j++){
        inches[i][j] = new Inch(i, j);
      }
    }
  }

  void apply(Patch p){
    for (int i = p.left; i < p.left + p.w; i++){
      for (int j = p.top; j < p.top + p.h; j++){
        this.inches[i][j].patches.add(p);
      }
    }
  }

  int getOverlap() {
    int overlap = 0;
    for (int i = 0; i < this.w; i++){
      for (int j = 0; j < this.h; j++){
        if (this.inches[i][j].patches.length > 1)
          overlap++;
      }
    }
    return overlap;
  }

  Patch getNonOverlap(){
    Map<String, Patch> pmap = new Map<String, Patch>();
    for (int i = 0; i < this.w; i++){
      for (int j = 0; j < this.h; j++){
          if (this.inches[i][j].patches.length == 0) continue;
          Patch p = this.inches[i][j].patches.first;
          pmap.putIfAbsent(p.id, () => p);
      }
    }

    for (int i = 0; i < this.w; i++){
      for (int j = 0; j < this.h; j++){
          if (this.inches[i][j].patches.length > 1){
            this.inches[i][j].patches.forEach((p) => pmap.remove(p.id));
          }
      }
    }

    return pmap.values.first;
  }
}

void main(){
  new File(input).readAsString().then((String contents){
    List<Patch> patches = new List<Patch>();
    var r = new RegExp(r"#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)");
    for (var line in contents.split("\n")){
      var m = r.firstMatch(line);
      if (m == null) continue;
      
      var left = int.parse(m.group(2));
      var top = int.parse(m.group(3));

      var w = int.parse(m.group(4));
      var h = int.parse(m.group(5));

      var p = new Patch(m.group(1), left, top, w, h);
      patches.add(p);
    }

    Quilt q = new Quilt(1000, 1000);
    patches.forEach((p) => q.apply(p));
    print(q.getOverlap());
    Patch p = q.getNonOverlap();
    print(p);
  });
}