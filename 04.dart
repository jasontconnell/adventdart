import "dart:io";
import "dart:core";
import "dart:math" as Math;
const input = "04.txt";

class GuardEntry {
  String id;
  String action;

  int month, day, year;
  int hour, minute;

  GuardEntry(String id, String action, int year, int month, int day, int hour, int minute){
    this.id = id.trim();
    this.action = action;
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = hour;
    this.minute = minute;
  }
  String sortKey() {
    return this.year.toString() + " " + this.month.toString().padLeft(2, "0") + " " + this.day.toString().padLeft(2, "0")
        + " " + this.hour.toString().padLeft(2, "0") + " " + this.minute.toString().padLeft(2, "0");
  }

  String toString(){
    return this.id + ": " + this.action + " --- " + this.sortKey() + "\n";
  }
}

void main(){
  new File(input).readAsString().then((String contents){
    List<GuardEntry> list = new List<GuardEntry>();
    for (var line in contents.split("\n")){
      GuardEntry g = getGuardEntry(line);
      list.add(g);
    }

    list.sort((a, b) => a.sortKey().compareTo(b.sortKey()));
    fillGuardIds(list);

    Map<String, List<int>> allSleeps = new Map<String, List<int>>();
    for (int i = 0; i < list.length; i++){
      var g = list[i];
      if (g.action == "awake"){
        var sl = list[i-1];
        if (sl.id != g.id) continue;

        for (int j = sl.minute; j < g.minute; j++){
          allSleeps.update(g.id, (v) { v[j]++; return v; }, ifAbsent: () => List<int>.filled(60, 0));
        }
      }
    }

    int mostAsleep = -1;
    String mostAsleepGuard = "";
    int mostAsleepMinute = -1;
    allSleeps.forEach((k,v) {
      int max = 0;
      v.forEach((iv) => max = Math.max(max, iv));

      mostAsleep = Math.max(max, mostAsleep);

      if (mostAsleep == max){
        mostAsleepGuard = k;
        mostAsleepMinute = v.indexOf(max);

        print("Guard " + mostAsleepGuard + " sleeps a ton in minute " + mostAsleepMinute.toString());
      }
    });

    print(mostAsleepGuard + " " + mostAsleep.toString() + " = " + (int.parse(mostAsleepGuard) * mostAsleepMinute).toString());

  });
}

void fillGuardIds(List<GuardEntry> list){
  String g = list.first.id;
  for (int i = 1; i < list.length; i++){
    if (list[i].id == "") list[i].id = g;
    else g = list[i].id;
  }
}

GuardEntry getGuardEntry(String line){
  var r = new RegExp(r"\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.+)");
  var acr = new RegExp(r"Guard #(\d+) begins shift");
  var m = r.firstMatch(line);
  int y = int.parse(m.group(1));
  int mon = int.parse(m.group(2));
  int d = int.parse(m.group(3));
  int h = int.parse(m.group(4));
  int min = int.parse(m.group(5));
  String action = m.group(6);
  var m2 = acr.firstMatch(action);
  String id = "";
  if (m2 == null){
    if (action == "falls asleep"){
      action = "sleep";
    } else {
      action = "awake";
    }
  } else {
    id = m2.group(1);
    action = "start";
  }

  GuardEntry ge = new GuardEntry(id, action, y, mon, d, h, min);
  return ge;
}