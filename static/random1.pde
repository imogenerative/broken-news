/*
Jo Fulton (033372)

Bachelor of Fine Arts with Honours
FSA415 Thesis - Research Project

"stay tuned for more" frontend
(C) Jo Fulton, 2012.
*/


//master list of news headlines from the Python backend
String[] QUOTES = loadStrings("static/master.txt");

int HNUM= 150; //the number of headline objects to be displayed onscreen
int FG = 127; 
int BG = 40; 

int DELAY = 3600000; //milliseconds in 1 hour
int TIME = millis(); //execution time

Headline[] headlineList = new Headline[HNUM];

void setup() {
  size(window.innerWidth, window.innerHeight);
    
  //initiate the headline objects to be displayed
  for (int i = 0; i < HNUM; i++) {
    headlineList[i] = new Headline(color(FG), random(30,55), random(5,30));
  }
}

void draw () {
  background(BG);
  
  //execute the class methods to animate each object
  for (int i = 0; i < HNUM; i++) {
    headlineList[i].display();
    headlineList[i].pulse();
  }
  
  if (millis() - DELAY == TIME) {
    
    //reload headlines each hour
    QUOTES = loadStrings("http://198.58.102.140/master.txt");
    TIME = millis();
  }
}    

class Headline {
  color c; 
  float xpos;
  float ypos;
  float tsize;
  float alphaVal = 0;
  float pulseSpeed;
  int xWidth = window.innerWidth;
  int yHeight = window.innerHeight;
  int randquote;
  int direction = 1;
  
  Headline(color tempC, float tempSize, float tempPulse) {
    
    //input variables
    c = tempC;
    tsize = tempSize;
    pulseSpeed = tempPulse;
    
    //random position onscreen
    xpos = random(-300, xWidth);
    ypos = random(-100, yHeight);
    
    //select a quote to be used
    randquote = int(random(QUOTES.length - 1));
  }
  
  //render and display the text
  void display() {
    fill(c, alphaVal);
    textSize(tsize);
    text(QUOTES[randquote], xpos, ypos);
  }
    
  void pulse() {
    
    //fade text in
    if (direction == 1 && alphaVal < 255) {
      alphaVal = alphaVal + pulseSpeed;
      
      //at 100% opacity, switch mode to fade out
      if (alphaVal > 255 ) {
        alphaVal = 255;
        direction = 0;
      }
    }
    
    //fade text out
    if (direction == 0 && alphaVal > 0) {
      alphaVal = alphaVal - pulseSpeed;
      
      //at 0% opacity, set mode to reset
      if (alphaVal < 0) {
        alphaVal = 0;
        direction = 2;
        xpos = random(-300, xWidth);
        ypos = random(-100, yHeight);
      }
    }
    
    //reset the text object
    if (direction == 2) {
      direction = 1;
      alphaVal = 0;
      randquote = int(random(QUOTES.length - 1));
    }
  }
}
