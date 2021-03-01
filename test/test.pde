import processing.net.*;

/*
  to-do:
  - get timeout to work on other pages
    (timeout is not implemented well - only works once)
  - enable double tap
  - display settings
  - display history
  - network library
  - positioning of settings buttons
  - convert changes in weight so can display in lbs too
  - function to increase/decrease font size
*/

//buttons for settings, history & control ("home")
RectButton settingsBtn, historyBtn;
CircButton controlBtn;

RectButton toggleCm;
RectButton toggleKg;
RectButton fontPlus;
RectButton fontMinus;

//variable to store screen state
int state = 1;
int xTxt=width+335;//x positioning of text at right hand side panel

int font = 24;

//height & weight units setting
boolean isKg = true;
boolean isCm = true;

//user 1 (john)
User u1;

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
  
  u1 = new User("John", 178, 90, 25);
}

void draw(){
  //make bg black
  background(0);
  textSize(font);
  
  //draw home/control button
  controlBtn.drawButton();
  
  displayScreen();
}

void displayScreen(){
  //conditional block to control which screen to display
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
  if(state == 3){
    boolean isOnCm = mouseX > toggleCm.x-toggleCm.w/2 && mouseX < toggleCm.x+toggleCm.w/2
                     && mouseY > toggleCm.y-toggleCm.h/2 && mouseY < toggleCm.y+toggleCm.h/2;
                     
    boolean isOnKg = mouseX > toggleKg.x-toggleKg.w/2 && mouseX < toggleKg.x+toggleKg.w/2
                     && mouseY > toggleKg.y-toggleKg.h/2 && mouseY < toggleKg.y+toggleKg.h/2;
  
    if(isOnCm){
      isCm = !isCm;
    }
     
    if(isOnKg){
      isKg = !isKg;
    }
  }
}

//what to display when screen/display is off
void displayOff(){}

//this is shown when john stands on the mat i guess
//welcomes him
void displayWelcome(){
  text("Hello " + u1.name, width/2-57, height/2-25);
  text("Would you like to weigh yourself?", width/2-180, height/2+25);
}

//displays the display/dashboard
void displayDisplay(){
  displayDate();
  
  settingsBtn.drawButton();
  historyBtn.drawButton();
  
  u1.displayUserProfile();
  
  for (int i= 250; i<=610; i=i+180){
    noFill();
    rect(490,i, 130,150,7);
  }//3 display boxes on the right hand side
  
  text("Weight:", xTxt, 230);
  if(isKg){
    text(u1.getKg() + "kg", xTxt, 260);
  } else {
    text(u1.getLb() + "lbs", xTxt, 260);
  }
  
  text("BMI:", xTxt, 410);
  text(u1.calculateBMI(), xTxt, 440);
  
  text("Body fat:", xTxt, 590);
  text(u1.getBodyFat(), xTxt, 620);
  
  textSize(font/1.6);
  text("-1kg", xTxt, 280);
  text("-0.3", xTxt, 460);
  text("-0.2%", xTxt, 640);
}

//displays the settings
void displaySettings(){  
  toggleCm = new RectButton(width/3*2, height/7*4.5, 50, 40, "cm");
  toggleKg = new RectButton(width/3*2, height/7*5, 50, 40, "kg");
  fontPlus = new RectButton(width/3*2+80, height/7*5.5, 50, 40, "+");
  fontMinus = new RectButton(width/3*2, height/7*5.5, 50, 40, "-");
  
  text("Settings", width/2-42, height/7);
  //personal settings
  text("Personal", width/2-43, height/7*1.5);
  
  //height
  if(isCm){
    text("Height: " + u1.getCm() + "cm", width/2-45, height/7*2);
  } else {
    text("Height: " + u1.getFtInch(), width/2-45, height/7*2);
  }
  
  //system settings
  text("System", width/2-42, height/7*4);
  
  if(isCm){
    text("Units (height): cm", width/2-45, height/7*4.5);
  } else {
    text("Units (height): ft", width/2-45, height/7*4.5);
  }
  
  toggleCm.drawButton();
  
  if(isKg){
    text("Units (weight): kg", width/2-45, height/7*5);
  } else {
    text("Units (weight): lbs", width/2-45, height/7*5);
  }
  
  toggleKg.drawButton();
  
  text("Font size: " + font, width/2-45, height/7*5.5);
  fontMinus.drawButton();
  fontPlus.drawButton();
}

//displays the history
void displayHistory(){
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
