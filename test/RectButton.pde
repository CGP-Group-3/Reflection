class RectButton extends Button {
  String label;
  float labelX;
  float labelY;
  
  //constructor
  RectButton(float tempX, float tempY, float tempW, float tempH, String tempLabel, float tempLabelX, float tempLabelY){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
    labelX = tempLabelX;
    labelY = tempLabelY;
  }
  
  //draws a rectangle and writes the button name/label on it
  void drawButton(){
    boolean isOnButton = mouseX > x-w/2 && mouseX < x+w/2
                         && mouseY > y-h/2 && mouseY < y+h/2;
    
    if(mousePressed && isOnButton){
      rectMode(CENTER);
      fill(255);
      stroke(255);
      rect(x, y, w, h, 5);
      fill(26);
      textSize(fontSize);
      text(label, x-labelX, y+labelY);
      fill(255);
    } else {
      rectMode(CENTER);
      noFill();
      stroke(255);
      rect(x, y, w, h, 5);
      fill(255);
      textSize(fontSize);
      text(label, x-labelX, y+labelY);
    }
  }
  
  //draws a rectangle and writes the button name/label on it
  //but it also takes a boolean to check if the button should show feedback
  //used on kg/lb & cm/ft buttons to show which is active
  void drawButton(boolean b){          
    if(b){
      rectMode(CENTER);
      fill(255);
      stroke(255);
      rect(x, y, w, h, 5);
      fill(26);
      textSize(fontSize);
      text(label, x-labelX, y+labelY);
      fill(255);
    } else {
      rectMode(CENTER);
      noFill();
      stroke(255);
      rect(x, y, w, h, 5);
      fill(255);
      textSize(fontSize);
      text(label, x-labelX, y+labelY);
    }
  }
}
