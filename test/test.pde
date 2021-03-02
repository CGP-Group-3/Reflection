import processing.net.*;

/*
  to-do:
  - get timeout to work on other pages
    (timeout is not implemented well - only works once)
  - enable double tap?
  - display settings
  - display history
  - network library
  - positioning of settings buttons
  - convert changes in weight so can display in lbs too
  - method for inputting height
  - method for inputting blood pressure?
*/

//buttons for settings, history & control ("home")
RectButton settingsBtn, historyBtn;
CircButton controlBtn;

//buttons for toggling between units (cm & ft and kg & lbs)
RectButton toggleCm;
RectButton toggleKg;

//buttons for increasing and decreasing font size
RectButton fontPlus;
RectButton fontMinus;

RectButton changeH;

//variable to store screen state
int state = 1;
int xTxt=width+335;//x positioning of text at right hand side panel

int fontSize = 24;

//height & weight units setting
boolean isKg = true;
boolean isCm = true;

//user 1 (john)
User u1;

//array for numPadArr button labels
String[] labelArr = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "enter", "backspace"};
//array of RectButtons for number pad
RectButton[] numPadArr = new RectButton[labelArr.length];

boolean shouldNumPadDisplay = false;

void setup(){
  //set size of display/sketch
  size(600, 900);
  
  //x, y & width for buttons
  int x = 100;
  int y = 90;
  int w = 150;
  
  //instantiating buttons
  settingsBtn = new RectButton(x, y, w, 40, "Settings");
  historyBtn = new RectButton(x+w+20, y, w, 40, "History");
  controlBtn = new CircButton(width/2, height-80, 45, 45);
  
  //instantiate u1
  u1 = new User("John", 178, 90, 25);
  
  //instantiating num pad buttons 1 to 9
  int a = 1;
  int b = 1;
  for(int i = 1; i < 4; i++){
    for(int j = 1; j < 4; j++){
      numPadArr[b] = new RectButton(width/5*j, height/9*(i+3), 80, 80, labelArr[a]);
      a++;
      b++;
    }
  }
  
  numPadArr[0] = new RectButton(width/5*2, height/9*7, 80*3, 80, labelArr[0]);
  numPadArr[numPadArr.length-2] = new RectButton(width/5*4, height/9*6.5, 80, 80*2, labelArr[numPadArr.length-2]);
  numPadArr[numPadArr.length-1] = new RectButton(width/5*4, height/9*4.4, 80, 80, labelArr[numPadArr.length-1]);
}

void draw(){
  //make bg black
  background(0);
  textSize(fontSize);
  
  //draw home/control button
  controlBtn.drawButton();
  
  //display interface
  displayScreen();
}

void displayScreen(){
  //conditional block to control which screen to display
  //0 is off
  //1 is welcome
  //2 is the dashboard
  //3 is settings
  //4 is history
  if(state == 0){
    displayOff();
    wakeDisplay();
  } else if(state == 1){
    displayWelcome();
    timeoutDisplay();
    controlBtn.hoverButton(2);
  } else if(state == 2){
    displayDisplay();
    settingsBtn.hoverButton(3);
    historyBtn.hoverButton(4);
  } else if(state == 3){
    displaySettings();
    controlBtn.hoverButton(2);
  } else if(state == 4){
    displayHistory();
    controlBtn.hoverButton(2);
  }
}

void mouseReleased(){
  //when on settings page...
  if(state == 3){
    //...if mouse is over the cm/kg button...
    boolean isOnCm = mouseX > toggleCm.x-toggleCm.w/2 && mouseX < toggleCm.x+toggleCm.w/2
                     && mouseY > toggleCm.y-toggleCm.h/2 && mouseY < toggleCm.y+toggleCm.h/2;
    boolean isOnKg = mouseX > toggleKg.x-toggleKg.w/2 && mouseX < toggleKg.x+toggleKg.w/2
                     && mouseY > toggleKg.y-toggleKg.h/2 && mouseY < toggleKg.y+toggleKg.h/2;
  
    //...toggle height unit
    if(isOnCm){
      isCm = !isCm;
    }
     
    //toggle weight unit
    if(isOnKg){
      isKg = !isKg;
    }
    
    //if mouse if over font increase/decrease button
    boolean isOnPlus = mouseX > fontPlus.x-fontPlus.w/2 && mouseX < fontPlus.x+fontPlus.w/2
                       && mouseY > fontPlus.y-fontPlus.h/2 && mouseY < fontPlus.y+fontPlus.h/2;
    boolean isOnMinus = mouseX > fontMinus.x-fontMinus.w/2 && mouseX < fontMinus.x+fontMinus.w/2
                        && mouseY > fontMinus.y-fontMinus.h/2 && mouseY < fontMinus.y+fontMinus.h/2;
    
    //increase font size
    if(isOnPlus && fontSize <= 36){
      fontSize += 4;
    }
     
    //decrease font size
    if(isOnMinus && fontSize >= 24){
      fontSize -= 4;
    }
    
    //if mouse over change height button
    boolean isOnChangeH = mouseX > changeH.x-changeH.w/2 && mouseX < changeH.x+changeH.w/2
                          && mouseY > changeH.y-changeH.h/2 && mouseY < changeH.y+changeH.h/2;
    
    //toggle input num pad
    if(isOnChangeH){
      shouldNumPadDisplay = !shouldNumPadDisplay;    
      //i should be able to switch units
      //i should be able to input numbers
      //i should be able to backspace what i've written
      //i should be able to submit what i inputted
      //all of the above should be bundled as one unit/thing to reuse for input blood pressure
      //the system needs to restrict length of input
      //e.g. ft should be 1 number and must be greater than or equal to 0
      //inches can be 2 numbers between 0 (including) and 12 (excluding?)
    }
  }
}

//what to display when screen/display is off
void displayOff(){}

//this is shown when john stands on the mat i guess
//welcomes him
void displayWelcome(){
  textSize(fontSize);
  text("Hello " + u1.name, width/2-57, height/2-25);
  text("Would you like to weigh yourself?", width/2-180, height/2+25);
}

//displays the display/dashboard
void displayDisplay(){
  textSize(fontSize);
  displayDate();
  
  //draw settings and history buttons
  settingsBtn.drawButton();
  historyBtn.drawButton();
  
  //display user profile
  u1.displayUserProfile();
  
  //3 display boxes on the right hand side
  for (int i= 250; i<=610; i=i+180){
    noFill();
    rect(490,i, 130,150,7);
  }
  
  //display weight
  text("Weight:", xTxt, 230);
  if(isKg){
    text(u1.getKg() + "kg", xTxt, 260);
  } else {
    text(u1.getLb() + "lbs", xTxt, 260);
  }
  
  //display bmi
  text("BMI:", xTxt, 410);
  text(u1.calculateBMI(), xTxt, 440);
  
  //display body fat %
  text("Body fat:", xTxt, 590);
  text(u1.getBodyFat(), xTxt, 620);
  
  //display stat changes in weight, bmi and body fat %
  textSize(fontSize/1.6);
  text("-1kg", xTxt, 280);
  text("-0.3", xTxt, 460);
  text("-0.2%", xTxt, 640);
}

//displays the settings
void displaySettings(){
  //instantiate buttons located in the settings
  toggleCm = new RectButton(width/3*2, height/7*4.5, 140, 40, "switch units");
  toggleKg = new RectButton(width/3*2, height/7*5, 140, 40, "switch units");
  fontPlus = new RectButton(width/3*2+80, height/7*5.5, 50, 40, "+");
  fontMinus = new RectButton(width/3*2, height/7*5.5, 50, 40, "-");
  changeH = new RectButton(width/2-45, height/7*2, 140, 40, "change");
  
  textSize(fontSize);
  text("Settings", width/2-42, height/7);
  //personal settings
  text("Personal", width/2-43, height/7*1.5);
  
  //change height
  if(isCm){
    text("Height: " + u1.getCm() + "cm", width/2-45, height/7*2);
  } else {
    text("Height: " + u1.getFtInch(), width/2-45, height/7*2);
  }
  
  changeH.drawButton();
  
  //system settings
  text("System", width/2-42, height/7*4);
  
  //height units
  if(isCm){
    text("Units (height): cm", width/2-45, height/7*4.5);
  } else {
    text("Units (height): ft", width/2-45, height/7*4.5);
  }
  
  //display height unit switch button
  toggleCm.drawButton();
  
  //weight units
  if(isKg){
    text("Units (weight): kg", width/2-45, height/7*5);
  } else {
    text("Units (weight): lbs", width/2-45, height/7*5);
  }
  
  //display weight unit switch button
  toggleKg.drawButton();
  
  //display font size and increase/decrease font size buttons
  text("Font size: " + fontSize, width/2-45, height/7*5.5);
  fontMinus.drawButton();
  fontPlus.drawButton();
  
  displayNumPad();
}

//displays the history
void displayHistory(){
  textSize(fontSize);
  text("History", width/2-42, height/7);
}

//if u sit on the welcome screen for longer than 5s, display will go to sleep
//it doesn't work like i thought it would work
void timeoutDisplay(){
  float now = millis();
  
  if(now > 5000){
    state = 0;
  }
}

//turn display back on
void wakeDisplay(){
  controlBtn.hoverButton(2);
}

//display the time and date in top left
void displayDate(){
  int day = day();
  String d = "" + day;
  int month = month();
  String m = sortMonth(month);
  int year = year();
  int hour = hour();
  int mins = minute();
  String mins2 = "" + mins;
  
  //add 'st', 'nd', 'rd' or 'th' after day e.g. 21st, 22nd, 23rd, 24th
  if(day == 1 || day == 21 || day == 31){
    d += "st";
  } else if(day == 2 || day == 22){
    d += "nd";
  } else if(day == 3 || day == 23){
    d += "rd";
  } else {
    d += "th";
  }
  
  //formatting minutes because processing doesn't show single digits with leading zero
  if(mins < 10){
    mins2 = "0" + mins;
  } else {
    mins2 = str(mins);
  }
  
  textSize(fontSize);
  //write text to show time
  text(hour + ":" + mins2 + ", " + d + " " + m + " " + year, 30, 50);
}

//turn month from numbers into month name
String sortMonth(int month){
  String m = "";
  
  switch(month){
    case 1:
      m = "January";
      break;
    case 2:
      m = "February";
      break;
    case 3:
      m = "March";
      break;
    case 4:
      m = "April";
      break;
    case 5:
      m = "May";
      break;
    case 6:
      m = "June";
      break;
    case 7:
      m = "July";
      break;
    case 8:
      m = "August";
      break;
    case 9:
      m = "September";
      break;
    case 10:
      m = "October";
      break;
    case 11:
      m = "November";
      break;
    case 12:
      m = "December";
      break;
  }
  
  return m;
}

void displayNumPad(){
  if(shouldNumPadDisplay){
    fill(0);
    noStroke();
    rectMode(CORNER);
    rect(0, height/2, width, height/2-150);
    for(int i = 0; i < numPadArr.length; i++){
      numPadArr[i].drawButton();
    }
  }
}
