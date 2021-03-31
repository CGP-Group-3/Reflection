/*
  to-do:
 - get timeout to work (timeout is not implemented well - only works once)
 - way to input height (low priority)
 - input name (low priority)
 - motivational quote
 - goals
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
boolean isLb = false;
boolean isCm = true;
boolean isFt = false;

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
String[] motivationalQuotes = {"Good job John! Remember to drink water today.", 
  "Nice progress this week! Keep going!", 
  "Motivational quote 3", 
  "Motivational quote 4", 
  "Motivational quote 5"};

PImage backspace_w;
PImage confirm_w;
PImage backspace_b;
PImage confirm_b;

float barX;

void setup() {
  //set size of display/sketch
  size(600, 900);

  //x, y & width for buttons
  int x = 100;
  int y = 90;
  int w = 150;

  //loading images
  backspace_w = loadImage("images/backspace_white.png");
  confirm_w = loadImage("images/tick_white.png");
  backspace_b = loadImage("images/backspace_black.png");
  confirm_b = loadImage("images/tick_black.png");

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

  barX = records.getRowCount()-2;

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
  numPadArr[numPadArr.length-2] = new RectButton(xTxt+120, height/9*7.1, 40, 40, 
    labelArr[numPadArr.length-2], 8, 10, confirm_w, confirm_b);
  numPadArr[numPadArr.length-1] = new RectButton(xTxt, height/9*7.1, 40, 40, 
    labelArr[numPadArr.length-1], 8, 10, backspace_w, backspace_b);
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
  newest.setInt("id", records.getRowCount());
  newest.setString("date", day() + "/" + month() + "/" + year());
  newest.setFloat("weight", wRand);
  newest.setFloat("bmi", tempBMI);
  newest.setFloat("bodyfat", bodyFatRand);

  println("date : " + day() + "/" + month() + "/" + year() + ", weight difference: " + u1.getWeightDiff() + ", "
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
    //displayOff();
    //wakeDisplay();
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
      isFt = false;
    } else if (isOnFt) {
      isCm = false;
      isFt = true;
    }

    //toggle weight unit
    if (isOnKg) {
      isKg = true;
      isLb = false;
    } else if (isOnLb) {
      isKg = false;
      isLb = true;
    }

    //if mouse if over font increase/decrease button
    boolean isOnPlus = mouseX > fontPlus.x-fontPlus.w/2 && mouseX < fontPlus.x+fontPlus.w/2
      && mouseY > fontPlus.y-fontPlus.h/2 && mouseY < fontPlus.y+fontPlus.h/2;
    boolean isOnMinus = mouseX > fontMinus.x-fontMinus.w/2 && mouseX < fontMinus.x+fontMinus.w/2
      && mouseY > fontMinus.y-fontMinus.h/2 && mouseY < fontMinus.y+fontMinus.h/2;

    //increase font size
    if (isOnPlus && fontSize <= 24) {
      fontSize += 2;
    }

    //decrease font size
    if (isOnMinus && fontSize >= 24) {
      fontSize -= 2;
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
          if (dateArr[count] == '/') {
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

void mouseDragged() {
  if (state == 5) {
    if (mouseX > 30 && mouseX < width-30) {
      barX = map(mouseX, 30, width-30, 0, records.getRowCount()-1);
    }
  }
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
    text(u1.getWeightDiff() + "kg", xTxt, 280);
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
  toggleCm = new RectButton(width/3+25, 135, 50, 35, "cm", 17, 7);
  toggleFt = new RectButton(width/3+85, 135, 50, 35, "ft", 10, 7);
  toggleKg = new RectButton(width/3+25, 186, 50, 35, "kg", 15, 8);
  toggleLb = new RectButton(width/3+85, 186, 50, 35, "lb", 10, 8);
  fontPlus = new RectButton(width/3+85, 84, 50, 35, "+", 9, 8);
  fontMinus = new RectButton(width/3+25, 84, 50, 35, "-", 7.5, 8);

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
  toggleCm.drawButton(isCm);
  toggleFt.drawButton(isFt);

  //weight units
  text("Weight units", 30, 193);

  //display weight unit switch button
  toggleKg.drawButton(isKg);
  toggleLb.drawButton(isLb);

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
  //noFill();
  //displayNumPad();
}

//displays the history/visualisation
//SCREEN 5
void displayHistory() {
  //top side of mirror
  fill(255);
  textSize(fontSize+6);
  text("Welcome to your history, " + u1.name + "!", 30, 50);
  textSize(fontSize);
  text("Drag the pointer to see past measurements.", 30, 81);

  //display the visualisation at the top
  drawVisualisation(records.getInt(int(barX), "id"));
  drawBMI();

  ////right hand side of mirror
  //textSize(fontSize);

  ////display past weight
  //float yPos = 250;
  //text("Display results", xTxt-30, yPos);
  //text("for:", xTxt-30, yPos+30);
  //text(dateArr, 0, dateArr.length, xTxt-30, yPos+70);

  ////if the inputted date has no records then tell user that
  //if (!isValidDate) {
  //  textSize(fontSize/1.5);
  //  text("No record found, ", xTxt-30, yPos+95);
  //  text("please try a different day.", xTxt-32, yPos+115);
  //}

  ////show weight on that day
  //textSize(fontSize);
  //if (isKg) {
  //  text("Weight: " + w + "kg", xTxt-30, yPos+150);
  //} else {
  //  text("Weight: " + nf(u1.convertToLbs(float(w)), 0, 1) + "lbs", xTxt-30, yPos+150);
  //}

  ////show bmi on that day
  //text("BMI: " + b, xTxt-30, yPos+190);

  ////show body fat % on that day
  //text("Body fat: " + bf + "%", xTxt-30, yPos+230);

  //draw number pad
  //displayNumPad();
}

//if u sit on the welcome screen for longer than 5s, display will go to sleep
//it doesn't work like i thought it would work
//void timeoutDisplay(){
//  float t3 = millis();

//  if(t3 > 5000){
//    state = 0;
//  }
//}

////turn display back on
//void wakeDisplay() {
//  controlBtn.hoverButton(state);
//}

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
  for (int i = 0; i < numPadArr.length-2; i++) {
    numPadArr[i].drawButton();
  }

  numPadArr[numPadArr.length-2].drawButton(25, 25);
  numPadArr[numPadArr.length-1].drawButton(25, 25);
}

//function to show a random motivational quote
void displayMotivational() {  
  textSize(fontSize);
  text(motivationalQuotes[rand], 30, 153);
}

//draw the visualisation
//void drawVisualisation(){
////draw bar
//float y = 180;
//rectMode(CORNER);
//noStroke();
//fill(184, 51, 63);
//  rect(30, y, width-60, 20, 5);

//  float yellowX = map(15, 15, 35, 30, width-60);
//  float yellowW = map(30, 15, 35, 30, width-60);
//  fill(237, 214, 36);
//  rect(yellowX, y, yellowW-yellowX, 20, 5);

//  float greenX = map(18.5, 15, 35, 30, width-60);
//  float greenW = map(24.9, 15, 35, 30, width-60);
//  fill(17, 194, 26);
//  rect(greenX, y, greenW-greenX, 20, 5);
//  rectMode(CENTER);

////draw marker
//float markerX = map(u1.bmi, 15, 35, 30, width-60);
//float markerY = 140;
//int r = 50;
//fill(255);
//ellipse(markerX, markerY, r, r);
//triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);
//fill(26);
//  textSize(fontSize-4);
//  text(u1.bmi, markerX-27, markerY+8);

//  //reset to avoid impact on other elements being drawn
//  textSize(fontSize);
//  fill(255);
//}

void drawVisualisation() {
  //draw bar
  float y = 180;
  rectMode(CORNER);
  stroke(255);
  noFill();
  rect(30, y, width-60, 20, 5);

  //draw marker
  int num = records.getRowCount();
  float markerX = map(barX, 0, num-1, 30, width-30);
  float markerY = 140;
  int r = 50;
  fill(255);
  ellipse(markerX, markerY, r, r);
  triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);

  //right hand side of mirror
  textSize(fontSize);

  //display past weight
  float yPos = 250;
  text("Display results", xTxt-30, yPos);
  text("for:", xTxt-30, yPos+30);
  text(dateArr, 0, dateArr.length, xTxt-30, yPos+70);

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
}

void drawVisualisation(int a) {
  //draw bar
  float y = 190;
  rectMode(CORNER);
  stroke(255);
  strokeWeight(2);
  line(30, y, width-30, y);
  line(30, y-8, 30, y+8);
  line(width-30, y-8, width-30, y+8);
  strokeWeight(1);

  //draw marker
  int num = records.getRowCount();
  float markerX = map(barX, 0, num-1, 30, width-30);
  float markerY = 140;
  int r = 50;
  fill(255);
  ellipse(markerX, markerY, r, r);
  triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);

  //right hand side of mirror
  textSize(fontSize);

  //display past weight
  float yPos = 250;
  text("Displaying ", xTxt-30, yPos);
  text("result for:", xTxt-30, yPos+30);
  text(records.getString(a, "date"), xTxt-16, yPos+85);

  //show weight on that day
  textSize(fontSize);
  if (isKg) {
    text("Weight: " + nf(records.getFloat(a, "weight"), 0, 1) + "kg", xTxt-30, yPos+150);
  } else {
    text("Weight: " + nf(u1.convertToLbs(records.getFloat(a, "weight")), 0, 1) + "lbs", xTxt-30, yPos+150);
  }

  //show bmi on that day
  text("BMI: " + nf(records.getFloat(a, "bmi"), 0, 1), xTxt-30, yPos+190);

  //show body fat % on that day
  text("Body fat: " + nf(records.getFloat(a, "bodyfat"), 0, 1) + "%", xTxt-30, yPos+230);

  //reset
  fill(255);
  stroke(255);
  textSize(fontSize);
}

void drawBMI() {
  float yPos = 250;
  
  //draw bar for bmi
  textSize(fontSize-2);
  text("Current BMI: ", xTxt-30, yPos+340);

  float bmiY = yPos + 380;
  float bmiW = 180;
  rectMode(CORNER);
  noStroke();
  fill(184, 51, 63);
  rect(xTxt-30, bmiY, bmiW, 10, 5);

  float yellowX = map(15, 15, 35, xTxt-30, xTxt-30+bmiW);
  float yellowW = map(30, 15, 35, xTxt-30, xTxt-30+bmiW);
  fill(237, 214, 36);
  rect(yellowX, bmiY, yellowW-yellowX, 10, 5);

  float greenX = map(18.5, 15, 35, xTxt-30, xTxt-30+bmiW);
  float greenW = map(24.9, 15, 35, xTxt-30, xTxt-30+bmiW);
  fill(17, 194, 26);
  rect(greenX, bmiY, greenW-greenX, 10, 2);
  rectMode(CENTER);

  //draw bmi marker
  float bmiMarkerX = map(u1.bmi, 15, 35, xTxt-30, xTxt-30+bmiW);
  float bmiMarkerY = bmiY - 22;
  int bmiR = 25;
  fill(255);
  //ellipse(bmiMarkerX, bmiMarkerY, bmiR, bmiR);
  triangle(bmiMarkerX-bmiR/2+1, bmiMarkerY+7, bmiMarkerX, bmiMarkerY+bmiR, bmiMarkerX+bmiR/2-1, bmiMarkerY+7);

  textSize(fontSize-4);
  text("A healthy weight", xTxt-30, yPos+415);
  text("range for you: ", xTxt-30, yPos+440);
  float m = float(u1.cm) / 100;
  float lowerBound = 18.5 * sq(m);
  float upperBound = 24.9 * sq(m);
  if (isKg) {
    text(nf(lowerBound, 0, 1) + "kg ~ " + nf(upperBound, 0, 1) + "kg", xTxt-30, yPos+470);
  } else {
    text(nf(u1.convertToLbs(lowerBound), 0, 1) + "lbs ~ " + nf(u1.convertToLbs(upperBound), 0, 1) + "lbs", xTxt-30, yPos+470);
  }

  //reset
  fill(255);
  stroke(255);
  textSize(fontSize);
}
