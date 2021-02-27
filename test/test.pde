/*
  gabriele when u do the side panel,
  write your code in the function displayDisplay() pls
*/

/*
  to-do:
  - get timeout to work on other pages
    (timeout is not implemented well - only works once)
  - enable double tap
*/

RectButton settingsBtn, historyBtn;
CircButton controlBtn;
int state = 1;

void setup(){
  //set size of display/sketch
  size(600, 900);
  
  int x = 100;
  int y = 90;
  int w = 150;
  settingsBtn = new RectButton(x, y, w, 40, "Settings");
  historyBtn = new RectButton(x+w+20, y, w, 40, "History");
  controlBtn = new CircButton(width/2, height-80, 45, 45);
}

void draw(){
  //make bg black
  background(0);
  textSize(24);
  
  controlBtn.drawButton();
  
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

void displayOff(){}

void displayWelcome(){
  text("Hello John", width/2-57, height/2-25);
  text("Would you like to weigh yourself?", width/2-180, height/2+25);
}

void displayDisplay(){
  displayDate();
  
  settingsBtn.drawButton();
  historyBtn.drawButton();
}

void displaySettings(){
  text("settings", width/2, height/2);
}

void displayHistory(){
  text("history", width/2, height/2);
}

void timeoutDisplay(){
  float now = millis();
  
  if(now > 5000){
    state = 0;
  }
}

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
