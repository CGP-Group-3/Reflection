/*
  to-do:
 - get timeout to work (timeout is not implemented well - only works once)
 - motivational quote
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

//to store time
float t1;

//make a table object for getting & storing health records
Table records;

//count variable used to keep track of index position when inputting/backspacing date
int count = 0;

//variable to store random number
//to decide which quote to show
int rand;
String[] motivationalQuotes = {"Good job, " + u1.name + "! Remember to drink water today.", 
  "Nice progress this week! Keep going!"};

//variable to help draw visualisation
//for timeline
float barX;

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

  //set an initial value for barX for visualisation
  //should be most recent measurement
  barX = records.getRowCount()-2;

  //set rand to a random number
  //used for showing a random quote when he visits the dashboard
  rand = int(random(motivationalQuotes.length));
}

void draw() {
  //make bg black
  background(26);
  //set text size to fontSize
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
  //println("weight:" + wRand + ", body fat: " + bodyFatRand + ", bmi: " + tempBMI);

  //update john's current measurements
  u1.setKg(wRand);
  u1.setBodyFat(bodyFatRand);
  u1.setBMI(tempBMI);

  //add data to records table
  TableRow newest = records.addRow();
  newest.setInt("id", records.getRowCount());

  //formatting date for presentation purposes
  if (day() < 10 && month() < 10) {
    newest.setString("date", "0" + day() + "/0" + month() + "/" + year());
  } else if (day() < 10) {
    newest.setString("date", "0" + day() + "/" + month() + "/" + year());
  } else if (month() < 10) {
    newest.setString("date", day() + "/0" + month() + "/" + year());
  } else {
    newest.setString("date", day() + "/" + month() + "/" + year());
  }
  newest.setFloat("weight", wRand);
  newest.setFloat("bmi", tempBMI);
  newest.setFloat("bodyfat", bodyFatRand);

  //println("date : " + day() + "/" + month() + "/" + year() + ", weight difference: " + u1.getWeightDiff() + ", "
  //  + "bmi difference: " + u1.getBMIDiff() + ", "
  //  + "body fat difference: " + u1.getBodyFatDiff());

  //println("in lbs: " + u1.convertToLbs(u1.dW));

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
}

void mouseDragged() {
  //when on history/visualisation page
  if (state == 5) {
    //if the mouse's x position is within the range of the line drawn on the screen
    if (mouseX > 30 && mouseX < width-31) {
      //map the position to a record within the records.csv file
      //and assign it to barX to help draw the visualisation out
      barX = map(mouseX, 30, width-30, 0, records.getRowCount()-2);
    }
  }
}

//this is shown when john stands on the mat
//welcomes him
//SCREEN 1
void displayWelcome() {
  textSize(fontSize+6);
  text("Hello " + u1.name, width/2-57, height/4);
  textSize(fontSize);
  text("Would you like to weigh yourself?", width/2-180, height/4+40);

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

  //display switch height unit buttons
  toggleCm.drawButton(isCm);
  toggleFt.drawButton(isFt);

  //weight units
  text("Weight units", 30, 193);

  //display switch weight unit buttons
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

  //display the visualisations
  int row = records.getInt(int(barX), "id");
  drawVisualisation(row);
  drawBMI(row);
  drawBodyFat(row);
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

//function to show a random motivational quote
void displayMotivational() {  
  textSize(fontSize);
  text(motivationalQuotes[rand], 30, 153);
}

void drawVisualisation(int a) {
  //draw timeline
  float y = 190;
  rectMode(CORNER);
  stroke(255);
  strokeWeight(3);
  line(30, y, width-30, y);
  line(30, y-8, 30, y+8);
  line(width-30, y-8, width-30, y+8);
  strokeWeight(1);

  //label timeline
  textSize(fontSize-4);
  text("Oldest", 15, y+32);
  text("Newest", width-85, y+32);

  //draw marker on timeline
  int num = records.getRowCount();
  float markerX = map(barX, 0, num-2, 30, width-30);
  float markerY = 140;
  int r = 50;
  fill(255);
  ellipse(markerX, markerY, r, r);
  triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);

  //right hand side of mirror
  textSize(fontSize);

  //display weight on a specific day
  float yPos = 270;
  text("Displaying ", xTxt-30, yPos);
  text("result for:", xTxt-30, yPos+30);
  text(records.getString(a, "date"), xTxt-16, yPos+85);

  //show weight on that day
  textSize(fontSize);
  if (isKg) {
    text("Weight: " + nf(records.getFloat(a, "weight"), 0, 1) + "kg", xTxt-30, yPos+150);
  } else {
    text("Weight: " + round(u1.convertToLbs(records.getFloat(a, "weight"))) + "lbs", xTxt-30, yPos+150);
  }

  //show bmi on that day
  text("BMI: " + nf(records.getFloat(a, "bmi"), 0, 1), xTxt-30, yPos+190);

  //show body fat % on that day
  text("Body fat: " + nf(records.getFloat(a, "bodyfat"), 0, 1) + "%", xTxt-30, yPos+370);

  //reset to avoid ruining other parts of display
  fill(255);
  stroke(255);
  textSize(fontSize);
}

void drawBMI(int a) {
  float yPos = 255;

  //draw bar for bmi
  float bmiY = yPos + 250;
  float bmiW = 180;

  //unhealthy bmi bar
  rectMode(CORNER);
  noStroke();
  fill(184, 51, 63);
  rect(xTxt-30, bmiY, bmiW, 10, 5);

  //draw less unhealthy but still unhealthy part of bar
  float yellowX = map(15, 15, 35, xTxt-30, xTxt-30+bmiW);
  float yellowW = map(30, 15, 35, xTxt-30, xTxt-30+bmiW);
  fill(237, 214, 36);
  rect(yellowX, bmiY, yellowW-yellowX, 10, 5);

  //draw healthy bmi bar
  float greenX = map(18.5, 15, 35, xTxt-30, xTxt-30+bmiW);
  float greenW = map(24.9, 15, 35, xTxt-30, xTxt-30+bmiW);
  fill(17, 194, 26);
  rect(greenX, bmiY, greenW-greenX, 10, 2);
  rectMode(CENTER);

  //draw bmi marker along the bar
  float markerX = map(records.getFloat(a, "bmi"), 15, 35, xTxt-30, xTxt-30+bmiW);
  float markerY = bmiY - 22;
  int r = 25;
  fill(255);
  ellipse(markerX, markerY, r, r);
  triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);

  //display what would be a healthy bmi for user
  //bmi formula is bmi = kg/m^2
  textSize(fontSize-4);
  text("A healthy weight", xTxt-30, yPos+285);
  text("range for you: ", xTxt-30, yPos+305);
  float m = float(u1.cm) / 100;
  float lowerBound = 18.5 * sq(m);
  float upperBound = 24.9 * sq(m);

  //change ideal weight range according to lbs or kg setting
  if (isKg) {
    text(nf(lowerBound, 0, 1) + "kg ~ " + nf(upperBound, 0, 1) + "kg", xTxt-30, yPos+335);
  } else {
    text(nf(u1.convertToLbs(lowerBound), 0, 1) + "lbs ~ " + nf(u1.convertToLbs(upperBound), 0, 1) + "lbs", xTxt-30, yPos+335);
  }

  //reset to avoid ruining other parts of display
  fill(255);
  stroke(255);
  textSize(fontSize);
}

void drawBodyFat(int a) {
  float yPos = 440;

  //draw bar for body fat %
  //ranges from https://academic.oup.com/ajcn/article/72/3/694/4729363
  float bmiY = yPos + 250;
  float bmiW = 180;

  //draw all of bar but in red
  //slightly less unhealthy and healthy parts of bar will be drawn on top
  rectMode(CORNER);
  noStroke();
  fill(184, 51, 63);
  rect(xTxt-30, bmiY, bmiW, 10, 5);

  //draw less unhealthy but still unhealthy part of bar
  float yellowX = map(0, 0, 100, xTxt-30, xTxt-30+bmiW);
  float yellowW = map(30, 0, 100, xTxt-30, xTxt-30+bmiW);
  fill(237, 214, 36);
  rect(yellowX, bmiY, yellowW-yellowX, 10, 5);

  //draw healthy section
  float greenX = map(13, 0, 100, xTxt-30, xTxt-30+bmiW);
  float greenW = map(25, 0, 100, xTxt-30, xTxt-30+bmiW);
  fill(17, 194, 26);
  rect(greenX, bmiY, greenW-greenX, 10, 2);
  rectMode(CENTER);

  //draw body fat % marker along bar
  float markerX = map(records.getFloat(a, "bodyfat"), 0, 100, xTxt-30, xTxt-30+bmiW);
  float markerY = bmiY - 22;
  int r = 25;
  fill(255);
  ellipse(markerX, markerY, r, r);
  triangle(markerX-r/2+1, markerY+7, markerX, markerY+r, markerX+r/2-1, markerY+7);

  //show what would be healthy body fat %
  textSize(fontSize-4);
  text("A healthy body ", xTxt-30, yPos+285);
  text("fat % range for you: ", xTxt-30, yPos+305);
  text("13% ~ 24.9%", xTxt-30, yPos+335);

  //reset to avoid ruining other parts of display
  fill(255);
  stroke(255);
  textSize(fontSize);
}
