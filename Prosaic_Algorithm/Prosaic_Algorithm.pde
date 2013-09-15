float x;
int wMult = 0;

// HOW MANY VOICES TO INTRODUCE?
float[] voicesTH;
float[] colorsTH;
float[] wavesTH;
ArrayList voices = new ArrayList();
int voicesMax = 5;
int colorsMax = 7;
int wavesMax = 4;
int howManyNow = 0;
int howManyToAdd = 0;
int colorMax = 100;

boolean manualOverride = false;
boolean drawStacked = true;
boolean manualKill = false;
int manHowManyToAdd = 1;
boolean manModFreq = true;
int manWaveIndex = 1;


int bgColor = 0;
PFont font;

void setup() {
  size(displayWidth, displayHeight);
  colorMode(HSB, colorMax);
  background(bgColor);
  noFill();

  font = loadFont("SansSerif-16.vlw");
  textFont(font);

  // ROLL DICE TO SEE WHICH VOICES GET WHICH THRESHOLDS
  voicesTH = rollDie(voicesMax);
  colorsTH = rollDie(colorsMax);
  wavesTH = rollDie(wavesMax);
}

void draw() {
  updateInstructions();
  pushMatrix();
  translate(-width*wMult, 0);

  //IF THERE ARE ACTIVE VOICES...
  if (howManyNow > 0) {
    //ITERATE COUNTERS FOR EACH VOICE
    for (int i = howManyNow-1; i >=0; i--) {
      Voice thisVoice = (Voice)voices.get(i);
      int duration = thisVoice.duration;
      int counter = thisVoice.counter;
      if (counter > duration || manualKill) {
        //KILL THE VOICE & START UP NEW ONES
        voices.remove(i);
        howManyNow--;
        cueVoices();
        manualKill = false;
      }
      //ITERATE COUNTER FOR EACH VOICE
      else thisVoice.counter++;
    }
  }
  else cueVoices();


  //println( "HOW MANY VOICES? " + voices.size() );

  float totalY = 0;
  float posTotalY = 0;
  float negTotalY = 0;
  float y = 0;

  //DRAW CURVE FOR EACH ACTIVE VOICE
  for (int i = 0; i < howManyNow; i++) {
    Voice thisVoice = (Voice)voices.get(i);
    color strokeColor = thisVoice.strokeColor;
    float modFreq = thisVoice.modFreq;
    int waveIndex = thisVoice.waveIndex;
    y = drawOverlapped(thisVoice, waveIndex, strokeColor, 0);
    if (drawStacked) {
      totalY = drawStacked(thisVoice, waveIndex, strokeColor, y, posTotalY, negTotalY);
      if (totalY >=0 ) posTotalY = totalY;
      else negTotalY = totalY;
        }
      }
  x+=1.5;
  if (x > width*(wMult+1)) {
    wMult++;
    println("WIDTH MULTIPLIER: " + wMult);
    background(bgColor);
  }
  popMatrix();
}

void updateInstructions() {
  fill(0);
  noStroke();
  rect(0, 0, 1000, 140);
  fill(colorMax);
  text("ENTER: Manual \t SPACE: Modulate Freq \t +/-: No. Voices to Add \t 1: Sine \t 2: Square \t 3: Sawtooth \t 4: Tan \t TAB: Draw Stacked", 20, 20);
  text("MANUAL ON: " + manualOverride + "\t MANUAL KILL: " + manualKill, 20, 40);
  text("WHICH WAVE: " + manWaveIndex + "\t MOD F: " + manModFreq, 20, 60);
  text("NO. VOICES: " + howManyNow + "\t ADD: " + manHowManyToAdd, 20, 80);
  text("STACKED: " + drawStacked, 20, 100);
}

float drawOverlapped(Voice thisVoice, int waveIndex, color strokeColor, float y) {
  int anchor = int(height/4);

  //fetch correct curve
  switch(waveIndex) {
  case 1:
    y = thisVoice.newSine.run();
    //drawLine( anchor, y, strokeColor );
    break;  
  case 2:
    y = thisVoice.newSquare.run();
    //drawLine( anchor, y, strokeColor ); 
    break;  
  case 3:
    y = thisVoice.newSaw.run();
    //drawLine( anchor, y, strokeColor );
    break;
  case 4:
    y = thisVoice.newTan.run();
    //drawLine( anchor, y, strokeColor ); 
    break;  
  } 

  return y;
}

float drawStacked(Voice thisVoice, int waveIndex, color strokeColor, float y, float posTotalY, float negTotalY) {
  int anchor = int(height/2);
  float totalY = 0;
  
  if(y >=0) {
    totalY = posTotalY + y;  
  }
  else if(y < 0) {
    totalY = negTotalY + y;
  }
  
  drawLine( anchor, totalY, strokeColor );
  return totalY;
}

void cueVoices() {
  if (manualOverride) {
    howManyToAdd = manHowManyToAdd;
    voices = addVoices(howManyToAdd, voices);
    manHowManyToAdd = 1;
  }
  else {
    howManyToAdd = howManyToAdd(howManyNow);
    voices = addVoices(howManyToAdd, voices);
  }
  howManyNow = voices.size();

  println("HOW MANY VOICES? " + howManyNow + "\t" + "HOW MANY TO ADD? " + howManyToAdd);
}

void drawLine(float anchor, float y, color strokeColor) {
  stroke(strokeColor);
  line(x, anchor, x, anchor - int(y));
}

void keyPressed() {
  if (key == ENTER) manualOverride = !manualOverride;
  if (key == TAB) drawStacked = !drawStacked;
  if (key == 'k') manualKill = true;

  if (key == CODED) {
    if (keyCode ==UP) manHowManyToAdd++;
    else if (keyCode == DOWN) manHowManyToAdd--;
  }

  if (key == 32) manModFreq = !manModFreq;  

  // CHOOSE A PROBABILITY FUNCTION

  // SINE
  if (key == '1') manWaveIndex = 1;

  // SQUARE
  else if (key =='2') manWaveIndex = 2;

  // SAWTOOTH
  else if (key =='3') manWaveIndex = 3;

  // TANGENT
  else if (key == '4') manWaveIndex = 4;
}

