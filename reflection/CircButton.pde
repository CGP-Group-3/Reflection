class CircButton extends Button {
  //constructor
  CircButton(float tempX, float tempY, float tempW, float tempH){
    super(tempX, tempY, tempW, tempH);
  }
  
  //draws a circle
  void drawButton(){
    noFill();
    ellipse(x, y, w, h);
    stroke(255);
  }
}
