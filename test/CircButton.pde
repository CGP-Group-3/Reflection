class CircButton extends Button {
  //no, I do not know what I'm doing
  
  CircButton(int tempX, int tempY, int tempW, int tempH){
    super(tempX, tempY, tempW, tempH);
  }
  
  //draws a circle
  void drawButton(){
    noFill();
    ellipse(x, y, w, h);
    stroke(255);
  }
}
