class RectButton extends Button {
  String label;
  float labelX;
  float labelY;
  
  RectButton(float tempX, float tempY, float tempW, float tempH, String tempLabel, float tempLabelX, float tempLabelY){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
    labelX = tempLabelX;
    labelY = tempLabelY;
  }
  
  //draws a rectangle and writes the button name/label on it
  void drawButton(){
    rectMode(CENTER);
    noFill();
    stroke(255);
    rect(x, y, w, h, 5);
    fill(255);
    textSize(fontSize);
    text(label, x-labelX, y+labelY);
  }
}
