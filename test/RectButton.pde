class RectButton extends Button {
  String label;
  float labelX;
  float labelY;
  PImage i;
  PImage i2;
  
  RectButton(float tempX, float tempY, float tempW, float tempH, String tempLabel, float tempLabelX, float tempLabelY){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
    labelX = tempLabelX;
    labelY = tempLabelY;
  }
  
  RectButton(float tempX, float tempY, float tempW, float tempH,
             String tempLabel, float tempLabelX, float tempLabelY, PImage tempI, PImage tempI2){
    super(tempX, tempY, tempW, tempH);
    label = tempLabel;
    labelX = tempLabelX;
    labelY = tempLabelY;
    i = tempI;
    i2 = tempI2;
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
  
  void drawButton(float imgW, float imgH){
    boolean isOnButton = mouseX > x-w/2 && mouseX < x+w/2
                         && mouseY > y-h/2 && mouseY < y+h/2;
                         
    if(mousePressed && isOnButton){
      rectMode(CENTER);
      fill(255);
      stroke(255);
      rect(x, y, w, h, 5);
      fill(26);
      textSize(fontSize);
      image(i2, x-w/4-3, y-h/4-2, imgW, imgH);
      fill(255);
    } else {
      rectMode(CENTER);
      noFill();
      stroke(255);
      rect(x, y, w, h, 5);
      fill(255);
      textSize(fontSize);
      image(i, x-w/4-3, y-h/4-2, imgW, imgH);
    }
  }
  
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
