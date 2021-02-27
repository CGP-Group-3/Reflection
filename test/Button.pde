class Button{
  //width, height, start x, start y, button label/name
  int w;
  int h;
  int x;
  int y;
  
  //constructor
  Button(int tempX, int tempY, int tempW, int tempH){
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
