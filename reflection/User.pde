class User {
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

  //constructor
  User(String tempName, int tempCm, float tempKg, float tempBodyFat) {
    name = tempName;
    cm = tempCm;
    kg = tempKg;
    bodyfat = tempBodyFat;
  }

  //get height in cm
  int getCm() {
    return cm;
  }

  //string together ft and inches
  //get height in ft and inches
  String getFtInch() {
    convertToFtInch();
    return ft + "ft " + inch + "inches";
  }

  //get weight in kg
  String getKg() {
    return nf(kg, 0, 1);
  }

  //get weight in lb
  String getLb() {
    lbs = convertToLbs(kg);
    return "" + round(lbs);
  }

  //get bmi
  String getBMI() {
    return nf(bmi, 0, 1);
  }

  //function to convert ft and inches into cm
  int convertToCm() {
    int result = int(ft*30.48 + inch*2.54);
    return result;
  }

  //convert cm to ft and inches
  int convertToFtInch() {
    ft = int(cm/30.48);
    inch = int(((cm/30.48)-ft) % 12 * 10);
    return ft;
  }

  //convert lb to kg
  int convertToKg() {
    int result = int(lbs/2.205);
    return result;
  }

  //convert kg to lb
  float convertToLbs(float w) {
    float result = w*2.205;
    return result;
  }

  //calculate bmi
  float calculateBMI(int h, float w) {
    float m = float(h)/100;
    bmi = (w/sq(m));
    return bmi;
  }
  //BMI formula found from below, not altered in anyway
  //Coulman, K. and Toran, S. S. 2020, Body mass index may not be the best indicator of our health – how can we improve it?, The Conversation, viewed 5 April 2021, <https://theconversation.com/body-mass-index-may-not-be-the-best-indicator-of-our-health-how-can-we-improve-it-143155>.

  //get body fat
  String getBodyFat() {
    return nf(bodyfat, 0, 1) + "%";
  }

  //set weight
  void setKg(float w) {
    kg = w;
  }

  //set body fat
  void setBodyFat(float b) {
    bodyfat = b;
  }

  //set bmi
  void setBMI(float b) {
    bmi = b;
  }

  //calculate difference between last measurement and new measurement (kg ver)
  void calculateWeightDiff() {
    int num = records.getRowCount();
    dW = kg - records.getFloat(num-2, "weight");
  }

  //calculate difference between last measurement and new measurement (body fat % ver)
  void calculateBodyFatDiff() {
    int num = records.getRowCount();
    dBodyfat = bodyfat - records.getFloat(num-2, "bodyfat");
  }

  //calculate difference between last measurement and new measurement (bmi ver)
  void calculateBMIDiff() {
    int num = records.getRowCount();
    dBMI = bmi - records.getFloat(num-2, "bmi");
  }

  //get weight difference between last measurement and new measurement
  String getWeightDiff() {
    String str;

    calculateWeightDiff();

    if (isKg) {
      if (dW >= 0) {
        str = "+" + nf(dW, 0, 1);
      } else {
        str = nf(dW, 0, 1);
      }
    } else {
      if (dW >= 0) {
        str = "+" + nf(convertToLbs(dW), 0, 1);
      } else {
        str = "" + round(convertToLbs(dW));
      }
    }

    return str;
  }

  //get body fat % difference between last measurement and new measurement
  String getBodyFatDiff() {
    String str;

    calculateBodyFatDiff();

    if (dBodyfat >= 0) {
      str = "+" + nf(dBodyfat, 0, 1) + "%";
    } else {
      str = nf(dBodyfat, 0, 1) + "%";
    }

    return str;
  }

  //get bmi difference between last measurement and new measurement
  String getBMIDiff() {
    String str;

    calculateBMIDiff();

    if (dBMI >= 0) {
      str = "+" + nf(dBMI, 0, 1);
    } else {
      str = nf(dBMI, 0, 1);
    }

    return str;
  }
}
