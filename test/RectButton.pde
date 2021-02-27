class RectButton extends Button {
  String label;
  
  RectButton(int tempX, int tempY, int tempW, int tempH, String tempLabel){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
  }
  
  //draws a rectangle and writes the button name/label on it
  void drawButton(){
    rectMode(CENTER);
    noFill();
    rect(x, y, w, h, 5);
    stroke(255);
    text(label, x-w/3.5, y+h/4-1);
  }
}
