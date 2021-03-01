class Button{
  //width, height, start x, start y, button label/name
  float w;
  float h;
  float x;
  float y;
  
  //constructor
  Button(float tempX, float tempY, float tempW, float tempH){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }
  
  void hoverButton(int s){
    boolean isOnButton = mouseX > x-w/2 && mouseX < x+w/2
                         && mouseY > y-h/2 && mouseY < y+h/2;
    
    if(isOnButton){
      state = s;
    }
  }
}
