class Flag{
  int x;
  int y;
  
  Flag(int tempX, int tempY){
    x = tempX;
    y = tempY;
  }
  
  void drawFlag(){
    line(x, y, x, y-35);
    fill(255);
    triangle(x, y-35, x+18, y-27.5, x, y-20);
    noFill();
  }
}
