class Button{
  //width, height, start x, start y, button label/name
  int w;
  int h;
  int x;
  int y;
  String label;
  
  //constructor
  Button(int tempX, int tempY, int tempW, int tempH, String tempLabel){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    label = tempLabel;
  }
  
  //draws a square and writes the button name/label on it
  void drawButton(){
    noFill();
    rect(x, y, w, h, 5);
    stroke(255);
    text(label, x+w/5, y+h/2+8);
  }
}
