class User{
  String name;
  int cm;
  int ft;
  int inch;
  float kg;
  int lbs;
  float bodyfat;
  
  User(String tempName, int tempCm, float tempKg, float tempBodyFat){
    name = tempName;
    cm = tempCm;
    kg = tempKg;
    bodyfat = tempBodyFat;
  }
  
  void displayUserProfile(){
    noFill();
    rect(490, 80, 130, 130, 7);
    fill(255);
    textSize(font);
    text("profile", width/7*5.25, height/10);
  }
  
  int getCm(){
    return cm;
  }
  
  //string together ft and inches
  String getFtInch(){
    convertToFtInch();
    return ft + "ft " + inch + "inches";
  }
  
  String getKg(){
    return nf(kg, 0, 1);
  }
  
  String getLb(){
    lbs = convertToLbs();
    return nf(lbs, 0, 0);
  }
  
  int convertToCm(){
    int result = int(ft*30.48 + inch*2.54);
    return result;
  }
  
  int convertToFtInch(){
    ft = int(cm/30.48);
    inch = int(((cm/30.48)-ft) % 12 * 10);
    return ft;
  }
  
  int convertToKg(){
    int result = int(lbs/2.205);
    return result;
  }
  
  int convertToLbs(){
    int result = int(kg*2.205);
    return result;
  }
  
  String calculateBMI(){
    float m = float(cm)/100;
    float bmi = (kg/sq(m));
    return nf(bmi, 0, 1);
  }
  
  String getBodyFat(){
    return nf(bodyfat, 0, 1) + "%";
  }
}
