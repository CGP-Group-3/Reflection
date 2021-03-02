class RectButton extends Button {
  String label;
  
  RectButton(float tempX, float tempY, float tempW, float tempH, String tempLabel){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
  }
  
  //draws a rectangle and writes the button name/label on it
  void drawButton(){
    rectMode(CENTER);
    noFill();
    stroke(255);
    rect(x, y, w, h, 5);
    fill(255);
    textSize(fontSize);
    text(label, x-w/3.5, y+h/4-1);
  }
}
