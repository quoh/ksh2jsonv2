float bpm2ms (float bpm, int t) {
  float ms;
  float tmp = map(t, 1, 4, 4, 1);
  ms = 60/bpm*tmp*1000;
  return ms;
}
int getSectionTop;
int getSectionBottom;
int top;
int bottom;
int bpm;
int offset;
int nowMs;

String ksh2json (String str[]) {
  String jsn = "[";
  getSectionTop = -1;
  getSectionBottom = -1;
  top = 0;
  bottom = str.length;
  bpm = parseInt(str[7].substring(2, 5));
  println("bpm:"+bpm);
  offset = parseInt(str[10].substring(2));
  nowMs += offset;
  //for (int i=0 ;i<5; i++){
  while (top!=bottom) {
    println("top:"+top);
    println("bottom:"+bottom);
    println("jsn:"+jsn);
    getRange(top, bottom, str);
    jsn += picNotes(str);
    println("jsn:"+jsn);
  }
  jsn += "]";
  jsn.replace("}{","},{");
  jsn.replace("},]","}]");
  return jsn;
}

void getRange (int above, int under, String str[]) {
  for (int i=above; i<under; i++) {
    if (getSectionTop == -1) {
      if (str[i].equals("--")) {
        getSectionTop = i;
      }
    } else if (getSectionBottom == -1) {
      if (str[i].equals("--")) {
        getSectionBottom = i;
      }
    }
  }
}

String picNotes (String str[]) {
  //Section 1
  println("top:"+top);
  println("getSectionBottom:"+getSectionBottom);
  println("getSectionTop:"+getSectionTop);
  int barRange = getSectionBottom-getSectionTop-1;
  int tiles[] = new int [barRange];
  boolean noNote[] = new boolean [barRange];
  int cnt = 0;
  for (int i=getSectionTop+1; i<getSectionBottom; i++) {
    println("str["+i+"]:"+str[i]);
    String trg = str[i].substring(0, 4);
    if (!trg.equals("0000")&&!trg.equals("1000")&&!trg.equals("0100")&&!trg.equals("0010")&&!trg.equals("0001")) {
      noNote[i-(getSectionTop+1)] = true;
      cnt++;
    } else {
      noNote[i-(getSectionTop+1)] = false;
    }
  }
  //Section 2
  println(tiles.length-cnt);

  for (int i=0; i<tiles.length; i++) {
    String data = str[i+getSectionTop+1].substring(0, 4);
    println("data:"+data);
    if (!noNote[i]) {
      if (data.equals("1000")) {
        tiles[i] = 0;
      } else if (data.equals("0100")) {
        tiles[i] = 1;
      } else if (data.equals("0010")) {
        tiles[i] = 2;
      } else if (data.equals("0001")) {
        tiles[i] = 3;
      } else if (data.equals("0000")) {
        tiles[i] = 4;
      }
    } else {
      tiles[i] = -1;
    }
    println("tiles["+i+"]:"+tiles[i]);
  }
  //Section 3
  String json = "";
  float ms = bpm2ms(bpm, barRange-cnt);
  println("ms:"+ms);
  
  boolean put = false;
  
  for (int i=0; i<tiles.length; i++) {
    println("tiles["+i+"]:"+tiles[i]);
    println("nowMs:"+nowMs);
    if (tiles[i] == -1) {
    } else if (tiles[i] == 4) {
      nowMs += ms;
      noNote[i] = true;
    } else {
      json += "{\"start\":\""+nowMs+"\",\"tileNum\":\""+tiles[i]+"\"}";
      put = true;
      nowMs += ms;
    }
    if (!put || i == tiles.length-1) {
    } else if (!noNote[i]) {
      json += ",";
    }
    println("json:"+json);
  }
  top = getSectionBottom+1;
  getSectionTop = getSectionBottom;
  getSectionBottom = -1;
  return json;
}
