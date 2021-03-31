class Button{
  //width, height, start x, start y
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
  
  //function to change which screen to show
  void hoverButton(int s){
    //boolean to check if mouse is over the button
    boolean isOnButton = mouseX > x-w/2 && mouseX < x+w/2
                         && mouseY > y-h/2 && mouseY < y+h/2;
    
    //if the mouse is over the button and the mouse is being pressed
    //change the screen to whatever screen number was passed as the argument
    if(isOnButton && mousePressed){
      state = s;
    }
  }
}
