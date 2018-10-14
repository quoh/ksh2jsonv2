import javax.swing.*;
String getFile = null;
String[] str;
String _json;

void setup() {
  size(400, 800);
}

void draw() {
  background(255);
  if (getFile != null) {
    fileLoader();
    loadStr();
    noLoop();
  }
}

void keyPressed() {
  getFile = getFileName();
}

void fileLoader() {
  String ext = getFile.substring(getFile.lastIndexOf('.')+1);
  ext.toLowerCase();
  if (ext.equals("ksh"))println("coud load");
}

String getFileName() {
  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      try {
        JFileChooser fc = new JFileChooser();
        int returnVal = fc.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
          File file = fc.getSelectedFile();
          getFile = file.getPath();
        }
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
  );
  return getFile;
}

void loadStr(){
  println("getFile:"+getFile);
  str = loadStrings(getFile);
  _json = ksh2json(str);
  String title = str[0].substring(7);
  println("_json:"+_json);
  String js[] = new String [1];
  js[0] = _json;
  saveStrings(title+".json",js);
}
