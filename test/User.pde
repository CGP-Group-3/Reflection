class User{
  String name;
  int cm;
  int ft;
  int inch;
  float kg;
  float lbs;
  float bodyfat;
  float bmi;
  float dW;
  float dBodyfat;
  float dBMI;
  
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
    textSize(fontSize);
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
    lbs = convertToLbs(kg);
    return nf(lbs, 0, 0);
  }
  
  String getBMI(){
    return nf(bmi, 0, 1);
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
  
  float convertToLbs(float w){
    float result = w*2.205;
    return result;
  }
  
  float calculateBMI(int h, float w){
    float m = float(h)/100;
    bmi = (w/sq(m));
    return bmi;
  }
  
  String getBodyFat(){
    return nf(bodyfat, 0, 1) + "%";
  }
  
  void setKg(float w){
    kg = w;
  }
  
  void setBodyFat(float b){
    bodyfat = b;
  }
  
  void setBMI(float b){
    bmi = b;
  }
  
  void calculateWeightDiff(){
    int num = records.getRowCount();
    dW = kg - records.getFloat(num-2, "weight");
  }
  
  void calculateBodyFatDiff(){
    int num = records.getRowCount();
    dBodyfat = bodyfat - records.getFloat(num-2, "bodyfat");
  }
  
  void calculateBMIDiff(){
    int num = records.getRowCount();
    dBMI = bmi - records.getFloat(num-2, "bmi");
  }
  
  String getWeightDiff(){
    String str;
    
    calculateWeightDiff();
    
    if(isKg){
      if(dW >= 0){
        str = "+" + nf(dW, 0, 1);
      } else {
        str = nf(dW, 0, 1);
      }
    } else {
      if(dW >= 0){
        str = "+" + nf(convertToLbs(dW), 0, 1);
      } else {
        str = nf(convertToLbs(dW), 0, 1);
      }
    }
    
    return str;
  }
  
  String getBodyFatDiff(){
    String str;
    
    calculateBodyFatDiff();
    
    if(dBodyfat >= 0){
      str = "+" + nf(dBodyfat, 0, 1) + "%";
    } else {
      str = nf(dBodyfat, 0, 1) + "%";
    }
    
    return str;
  }
  
  String getBMIDiff(){
    String str;
    
    calculateBMIDiff();
    
    if(dBMI >= 0){
      str = "+" + nf(dBMI, 0, 1);
    } else {
      str = nf(dBMI, 0, 1);
    }
    
    return str;
  }
}
