Button settingsBtn, historyBtn;

void setup(){
  //set size of display/sketch
  size(500, 800);
  
  int x = 30;
  int w = 140;
  settingsBtn = new Button(x, 80, w, 40, "Settings");
  historyBtn = new Button(x+w+20, 80, w, 40, "History");
}

void draw(){
  //make bg black
  background(0);
  textSize(24);
  displayDate();
  
  settingsBtn.drawButton();
  historyBtn.drawButton();
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
  } else if(day == 3){
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
