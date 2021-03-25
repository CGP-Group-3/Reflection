/*
  to-do:
 - get timeout to work (timeout is not implemented well - only works once)
 - enable double tap
 - positioning of settings buttons
 - way to input height
 - input name
 - motivational quote
 - goals
 - create boolean active for each button, provide feedback for user when clicking
 */

//buttons for settings, history & control ("home")
RectButton settingsBtn, historyBtn;
CircButton controlBtn;

//buttons for toggling between units (cm & ft and kg & lbs)
RectButton toggleCm;
RectButton toggleFt;
RectButton toggleKg;
RectButton toggleLb;

//buttons for increasing and decreasing font size
RectButton fontPlus;
RectButton fontMinus;

//button for changing height, allows john to input new height
//RectButton changeH;

//variable to store screen state
int state = 1;

//x positioning of text at right hand side panel
int xTxt=width+335;

//variable to store text size
int fontSize = 24;

//height & weight units setting
//whether weight is kg or lbs
//whether height is cm or ft
boolean isKg = true;
boolean isCm = true;

//user 1 (john)
User u1;

//array for numPadArr button labels
String[] labelArr = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "enter", "delete"};

//array of RectButtons for number pad
RectButton[] numPadArr = new RectButton[labelArr.length];

//to store time
float t1;

//make a table object for getting & storing health records
Table records;

//array for date
//used in screen 5 - history/visualisation
//copy is used when backspacing so it shows date format
char[] dateArr = {' ', 'd', 'd', '/', 'm', 'm', '/', 'y', 'y', 'y', 'y'};
char[] dateArrCopy = {' ', 'd', 'd', '/', 'm', 'm', '/', 'y', 'y', 'y', 'y'};

//count variable used to keep track of index position when inputting/backspacing date
int count = 0;

//used for retrieving data from csv
String w = "0.0";
String b = "0.0";
String bf = "0.0";

//does the date exist in records.csv? (y/n)
//if no, will let user know that there is no record for that date
boolean isValidDate = true;

//TODO: think of something better
int rand;
String[] motivationalQuotes = {"Motivational quote 1", "Motivational quote 2",
                               "Motivational quote 3", "Motivational quote 4",
                               "Motivational quote 5"};

void setup() {
  //set size of display/sketch
  size(600, 900);

  //x, y & width for buttons
  int x = 100;
  int y = 90;
  int w = 150;

  //instantiating buttons
  settingsBtn = new RectButton(x, y, w, 40, "Settings", 42, 8);
  historyBtn = new RectButton(x+w+20, y, w, 40, "History", 40, 8);
  controlBtn = new CircButton(width/2, height-80, 45, 45);

  //instantiate u1
  u1 = new User("John", 178, 90, 25);

  //loads records.csv from folder
  records = loadTable("records.csv", "header");

  //mock up data for when john is measuring his weight
  mockData();

  //set rand to a random number
  //used for showing a random quote when he visits the dashboard
  rand = int(random(motivationalQuotes.length));

  //instantiating num pad buttons 1 to 9
  int a = 1;
  int b = 1;
  for (int i = 1; i < 4; i++) {
    for (int j = 0; j < 3; j++) {
      numPadArr[b] = new RectButton(xTxt+(60*j), height/9*4.7+(i*60), 40, 40, labelArr[a], 8, 10);
      a++;
      b++;
    }
  }

  //instantiating num pad buttons 0, enter and delete
  numPadArr[0] = new RectButton(xTxt+60, height/9*7.1, 40, 40, labelArr[0], 8, 10);
  numPadArr[numPadArr.length-2] = new RectButton(xTxt+120, height/9*7.1, 40, 40, labelArr[numPadArr.length-2], 8, 10);
  numPadArr[numPadArr.length-1] = new RectButton(xTxt, height/9*7.1, 40, 40, labelArr[numPadArr.length-1], 8, 10);
}

void draw() {
  //make bg black
  background(26);
  textSize(fontSize);

  //draw home/control button
  controlBtn.drawButton();

  //display interface
  displayScreen();
}

void mockData() {
  //mock up data (weight is in kg)
  float wRand = random(88, 94);
  float bodyFatRand = random(22, 26);
  float tempBMI = u1.calculateBMI(u1.cm, wRand);
  println("weight:" + wRand + ", body fat: " + bodyFatRand + ", bmi: " + tempBMI);

  //update john's current measurements
  u1.setKg(wRand);
  u1.setBodyFat(bodyFatRand);
  u1.setBMI(tempBMI);

  //add data to records table
  TableRow newest = records.addRow();
  newest.setString("date", day() + "/" + month() + "/" + year());
  newest.setFloat("weight", wRand);
  newest.setFloat("bmi", tempBMI);
  newest.setFloat("bodyfat", bodyFatRand);

  println("date : " + day() + "/" + month() + "/" + year() + "weight difference: " + u1.getWeightDiff() + ", "
    + "bmi difference: " + u1.getBMIDiff() + ", "
    + "body fat difference: " + u1.getBodyFatDiff());

  println("in lbs: " + u1.convertToLbs(u1.dW));

  //save the new row to the csv
  saveTable(records, "records.csv");
}

void displayScreen() {
  //conditional block to control which screen to display
  //0 is off
  //1 is welcome
  //2 is scanning screen
  //3 is the dashboard
  //4 is settings
  //5 is history
  if (state == 0) {
    displayOff();
    wakeDisplay();
  } else if (state == 1) {
    displayWelcome();
    //timeoutDisplay();
  } else if (state == 2) {
    displayScanning();
  } else if (state == 3) {
    displayDisplay();
    settingsBtn.hoverButton(4);
    historyBtn.hoverButton(5);
  } else if (state == 4) {
    displaySettings();
    controlBtn.hoverButton(3);
  } else if (state == 5) {
    displayHistory();
    controlBtn.hoverButton(3);
  }
}

void mouseReleased() {
  //when on settings page...
  if (state == 4) {
    //...if mouse is over the cm/ft/kg/lb button...
    boolean isOnCm = mouseX > toggleCm.x-toggleCm.w/2 && mouseX < toggleCm.x+toggleCm.w/2
      && mouseY > toggleCm.y-toggleCm.h/2 && mouseY < toggleCm.y+toggleCm.h/2;
    boolean isOnFt = mouseX > toggleFt.x-toggleFt.w/2 && mouseX < toggleFt.x+toggleFt.w/2
      && mouseY > toggleFt.y-toggleFt.h/2 && mouseY < toggleFt.y+toggleFt.h/2;
    boolean isOnKg = mouseX > toggleKg.x-toggleKg.w/2 && mouseX < toggleKg.x+toggleKg.w/2
      && mouseY > toggleKg.y-toggleKg.h/2 && mouseY < toggleKg.y+toggleKg.h/2;
    boolean isOnLb = mouseX > toggleLb.x-toggleLb.w/2 && mouseX < toggleLb.x+toggleLb.w/2
      && mouseY > toggleLb.y-toggleLb.h/2 && mouseY < toggleLb.y+toggleLb.h/2;

    //toggle height unit
    if (isOnCm) {
      isCm = true;
    } else if (isOnFt) {
      isCm = false;
    }

    //toggle weight unit
    if (isOnKg) {
      isKg = true;
    } else if (isOnLb) {
      isKg = false;
    }

    //if mouse if over font increase/decrease button
    boolean isOnPlus = mouseX > fontPlus.x-fontPlus.w/2 && mouseX < fontPlus.x+fontPlus.w/2
      && mouseY > fontPlus.y-fontPlus.h/2 && mouseY < fontPlus.y+fontPlus.h/2;
    boolean isOnMinus = mouseX > fontMinus.x-fontMinus.w/2 && mouseX < fontMinus.x+fontMinus.w/2
      && mouseY > fontMinus.y-fontMinus.h/2 && mouseY < fontMinus.y+fontMinus.h/2;

    //increase font size
    if (isOnPlus && fontSize <= 24) {
      fontSize += 4;
    }

    //decrease font size
    if (isOnMinus && fontSize >= 24) {
      fontSize -= 4;
    }
  }

  //if on history page
  if (state == 5) {
    //array of booleans to check if mouse is clicking/releasing over each num pad button
    boolean[] onNumPadKeyArr = new boolean[numPadArr.length];
    for (int i = 0; i < numPadArr.length; i++) {
      onNumPadKeyArr[i] = mouseX > numPadArr[i].x-numPadArr[i].w/2 && mouseX < numPadArr[i].x+numPadArr[i].w/2
        && mouseY > numPadArr[i].y-numPadArr[i].h/2 && mouseY < numPadArr[i].y+numPadArr[i].h/2;
    }

    //if a number pad button gets clicked
    for (int i = 0; i < numPadArr.length; i++) {
      if (onNumPadKeyArr[i]) {
        //if delete is clicked and count is at 0, then set count as 0
        //(don't let it become a negative number)
        //and set it to the empty date format
        if (numPadArr[i].label.equals("delete") && count == 0) {
          count = 0;
          dateArr[count] = dateArrCopy[count];
        } else if (numPadArr[i].label.equals("delete") && count > 0 && dateArr[count] == '/') {
          //if deleting and encounter a slash, skip over it and delete the number before the slash instead
          count--;
          dateArr[count] = dateArrCopy[count];
          count--;
        } else if (numPadArr[i].label.equals("delete") && count > 0) {
          //delete previous, decrement counter
          //set it to value of index in the empty date format array
          dateArr[count] = dateArrCopy[count];
          count--;
        } else if (count < dateArr.length-1 && !numPadArr[i].label.equals("enter")) {
          //the date arrays have an empty space char at index 0
          //so increment counter to start filling in date
          //this prevents weird results when you do a mix of entering and deleting
          count++;
          //if after the increment, the contents of that index is a slash,
          //increment counter again to skip over the slash
          if(dateArr[count] == '/'){
            count++; 
          }
          //set date to the number of the button
          //have to set condition to not accept the enter key as otherwise it will
          //take 'e' as the character to enter
          dateArr[count] = numPadArr[i].label.charAt(0);
        } else if (count < dateArr.length && !numPadArr[i].label.equals("enter")) {
          //if at last index, just set it to the number
          //no need to increment anymore
          //error otherwise
          dateArr[count] = numPadArr[i].label.charAt(0);
        } else if (numPadArr[i].label.equals("enter") && count == dateArr.length-1) {
          //if press enter
          //take the date inputted and make it a string
          //to search for the record in records.csv
          //need to use subset to get rid of empty space char at beginning of date array
          String d = new String(subset(dateArr, 1));
          u1.getWeightForDay(d);
          u1.getBMIForDay(d);
          u1.getBodyFatForDay(d);
          println("enter");
        }
      }
    }
  }
}

//what to display when screen/display is off
//(nothing, display nothing)
void displayOff() {
}

//this is shown when john stands on the mat
//welcomes him
//SCREEN 1
void displayWelcome() {
  textSize(fontSize);
  text("Hello " + u1.name, width/2-57, height/2-25);
  text("Would you like to weigh yourself?", width/2-180, height/2+25);

  //set t1 to however long the program has been running
  t1 = millis();

  //goes to screen 2 - scanning
  controlBtn.hoverButton(2);
}

//displayed when john is weighing himself
//SCREEN 2
void displayScanning() {
  //create boolean for when scale is done taking measurements
  boolean loaded = false;

  //display text letting john know what's going on
  textSize(fontSize+6);
  text("Scan in progress", width/3-20, height/4);
  textSize(fontSize);
  text("Please stay still", width/3+10, height/4+40);

  //scan progress bar total outline
  rect(30, height/3, width-60, 20, 7);

  //progress bar
  fill(255);
  //subtract t2 from t1 to make it zero for load bar to work properly
  //not doing this will make the load bar start when program starts running
  //rather than from when this screen is displayed
  float t2 = millis() - t1;
  if (t2 < width*4-240 && !loaded) {
    //width is set to a quarter of t2 to slow down bar
    rect(30, height/3, t2/4, 20, 7);
  } else {
    rect(30, height/3, width-60, 20, 7);

    //loaded is true
    //finished scanning
    loaded = !loaded;
  }

  //if scanning has been completed then below text will display
  //user has ability to choose to view dashboard now too
  if (loaded) {
    fill(26);
    noStroke();
    rect(width/4, height/4-35, 800, 80);
    fill(255);
    textSize(fontSize+6);
    text("Scan complete", width/3, height/4);
    textSize(fontSize);
    text("tap the circle to view the results", width/3-80, height/4+40);
    stroke(255);
    controlBtn.hoverButton(3);
  }
}

//displays the display/dashboard
//SCREEN 3
void displayDisplay() {
  //change text size
  textSize(fontSize);

  //display current date and time
  displayDate();

  //draw settings and history buttons
  settingsBtn.drawButton();
  historyBtn.drawButton();

  //show motivational quotes
  displayMotivational();

  //display user profile
  u1.displayUserProfile();

  //3 display boxes on the right hand side
  for (int i= 250; i<=610; i=i+180) {
    noFill();
    rect(490, i, 130, 150, 7);
  }

  //display weight
  text("Weight:", xTxt, 230);
  if (isKg) {
    text(u1.getKg() + "kg", xTxt, 260);
    textSize(fontSize/1.6);
    text(u1.getWeightDiff() + " kg", xTxt, 280);
  } else {
    text(u1.getLb() + "lbs", xTxt, 260);
    textSize(fontSize/1.6);
    text(u1.getWeightDiff() + " lbs", xTxt, 280);
  }

  //display bmi
  textSize(fontSize);
  text("BMI:", xTxt, 410);
  text(u1.getBMI(), xTxt, 440);

  //display body fat %
  text("Body fat:", xTxt, 590);
  text(u1.getBodyFat(), xTxt, 620);

  //display stat changes in weight, bmi and body fat %
  textSize(fontSize/1.6);
  text(u1.getBMIDiff(), xTxt, 460);
  text(u1.getBodyFatDiff(), xTxt, 640);
}

//displays the settings
//SCREEN 4
void displaySettings() {
  //instantiate buttons located in the settings
  toggleCm = new RectButton(width/3+10, 135, 50, 35, "cm", 17, 7);
  toggleFt = new RectButton(width/3+70, 135, 50, 35, "ft", 10, 7);
  toggleKg = new RectButton(width/3+10, 186, 50, 35, "kg", 15, 8);
  toggleLb = new RectButton(width/3+70, 186, 50, 35, "lb", 10, 8);
  fontPlus = new RectButton(width/3+70, 84, 50, 35, "+", 9, 8);
  fontMinus = new RectButton(width/3+10, 84, 50, 35, "-", 7.5, 8);
  //changeH = new RectButton(width/2-45, height/7*2, 140, 40, "change", 35, 8);

  //system settings
  textSize(fontSize+6);
  text("System Settings", 30, 50);

  //display font size and increase/decrease font size buttons
  textSize(fontSize);
  text("Font size: " + fontSize, 30, 93);
  fontMinus.drawButton();
  fontPlus.drawButton();

  //height units
  text("Height units", 30, 143);

  //display height unit switch button
  toggleCm.drawButton();
  toggleFt.drawButton();

  //weight units
  text("Weight units", 30, 193);

  //display weight unit switch button
  toggleKg.drawButton();
  toggleLb.drawButton();

  //personal settings
  textSize(fontSize+6);
  text("Personal Settings", width/2+30, 50);

  textSize(fontSize);
  text("Name: " + u1.name, width/2+30, 93);
  //height
  if (isCm) {
    text("Height: " + u1.getCm() + "cm", width/2+30, 143);
  } else {
    text("Height: " + u1.getFtInch(), width/2+30, 143);
  }

  //draw input number pad
  noFill();
  displayNumPad();
}

//displays the history/visualisation
//SCREEN 5
void displayHistory() {
  //top side of mirror
  textSize(fontSize+6);
  text("Welcome to your history, " + u1.name + "!", 30, 50);
  textSize(fontSize);
  text("Here is your current progress.", 30, 83);

  //display the visualisation at the top
  drawVisualisation();

  //right hand side of mirror
  textSize(fontSize);

  //display past weight
  float yPos = 250;
  text("Display results", xTxt-30, yPos);
  text("for:", xTxt-30, yPos+30);
  text(dateArr, 0, dateArr.length, xTxt-30, yPos+70);

  //if the inputted date has no records then tell user that
  if (!isValidDate) {
    textSize(fontSize/1.5);
    text("No record found, please try a different date", xTxt-30, yPos+100);
  }

  //show weight on that day
  textSize(fontSize);
  if (isKg) {
    text("Weight: " + w + "kg", xTxt-30, yPos+150);
  } else {
    text("Weight: " + nf(u1.convertToLbs(float(w)), 0, 1) + "lbs", xTxt-30, yPos+150);
  }

  //show bmi on that day
  text("BMI: " + b, xTxt-30, yPos+190);

  //show body fat % on that day
  text("Body fat: " + bf + "%", xTxt-30, yPos+230);

  //draw number pad
  displayNumPad();
}

//if u sit on the welcome screen for longer than 5s, display will go to sleep
//it doesn't work like i thought it would work
//void timeoutDisplay(){
//  float t3 = millis();

//  if(t3 > 5000){
//    state = 0;
//  }
//}

//turn display back on
void wakeDisplay() {
  controlBtn.hoverButton(1);
}

//display the time and date in top left
void displayDate() {
  int day = day();
  String d = "" + day;
  int month = month();
  String m = sortMonth(month);
  int year = year();
  int hour = hour();
  int mins = minute();
  //convert minutes into string
  String mins2 = "" + mins;

  //add 'st', 'nd', 'rd' or 'th' after day e.g. 21st, 22nd, 23rd, 24th
  if (day == 1 || day == 21 || day == 31) {
    d += "st";
  } else if (day == 2 || day == 22) {
    d += "nd";
  } else if (day == 3 || day == 23) {
    d += "rd";
  } else {
    d += "th";
  }

  //formatting minutes because processing doesn't show single digits with leading zero
  if (mins < 10) {
    mins2 = "0" + mins;
  } else {
    mins2 = str(mins);
  }

  textSize(fontSize+6);
  //write text to show time
  text(hour + ":" + mins2 + ", " + d + " " + m + " " + year, 30, 50);
}

//turn month from numbers into month name
String sortMonth(int month) {
  String m = "";

  switch(month) {
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

//draw every button in number pad
void displayNumPad() {
  noStroke();
  rectMode(CORNER);
  rect(0, height/2, width, height/2-150);
  for (int i = 0; i < numPadArr.length; i++) {
    numPadArr[i].drawButton();
  }
}

//function to show a random motivational quote
void displayMotivational() {  
  textSize(fontSize);
  text(motivationalQuotes[rand], 30, 153);
}

//draw the visualisation
void drawVisualisation() {  
  //drawing a line/flat ground
  float y = 210;
  strokeWeight(2);
  line(30, y, width-30, y);

  //bezier curve for mountain
  float x = 370;
  beginShape();
  vertex(x, y);
  bezierVertex(x+70, y, x+80, y-85, width-30-((width-30-x)/2), 120);
  bezierVertex(x+140, y-110, x+150, y, width-30, y);
  endShape();

  //quadratic curves for mountain snow
  fill(255);
  beginShape();
  vertex(x+81, y-65);
  quadraticVertex(x+75, y-43, x+98, y-55);
  quadraticVertex(x+112, y-35, x+125, y-55);
  quadraticVertex(x+152, y-43, x+139, y-65);
  quadraticVertex(width-30-((width-30-x)/2)+8, 93, x+81, y-65);
  endShape();

  //create and draw checkpoint flags
  Flag[] flagArr = new Flag[5];
  int[] flagX = {120, 180, 240, 300, 360};
  for (int i = 0; i < flagArr.length; i++) {
    flagArr[i] = new Flag(flagX[i], int(y));
    flagArr[i].drawFlag();
  }

  //draw end goal flag
  line(width-30-((width-30-x)/2)+8, 118, width-30-((width-30-x)/2)+8, 120-35);
  fill(255);
  rectMode(CORNER);
  rect(width-30-((width-30-x)/2)+8, 120-35, 20, 15);
  noFill();
  rectMode(CENTER);
  strokeWeight(1);
}
