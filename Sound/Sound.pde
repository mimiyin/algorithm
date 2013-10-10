import themidibus.*; //Import the library

float x;
int wMult = 0;

// HOW MANY VOICES TO INTRODUCE?
float[] voicesTH;
float[] colorsTH;
float[] wavesTH;


int voicesMax = 5;
ArrayList voices = new ArrayList();
boolean[] voiceRoster = new boolean[voicesMax];

int colorsMax = 7;
int wavesMax = 4;
int howManyNow = 0;
int howManyToAdd = 0;
int colorMax = 100;

boolean manualOverride = false;
boolean manualKill = false;
int manHowManyToAdd = 0;
boolean manModFreq = true;
int manWaveIndex = 1;


int bgColor = 0;
PFont font;


MidiBus myBus; // The MidiBus
int channel = 10;
int velocity = 127;
int number = 0;
int value = 90;
int beanMin = 0;


void setup() {
  size(600, 400);
  colorMode(HSB, colorMax);
  background(bgColor);
  noFill();

  font = loadFont("SansSerif-16.vlw");
  textFont(font);

  // ROLL DICE TO SEE WHICH VOICES GET WHICH THRESHOLDS
  voicesTH = rollDie(voicesMax);
  colorsTH = rollDie(colorsMax);
  wavesTH = rollDie(wavesMax);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.    
  myBus = new MidiBus(this, -1, "Java Sound Synthesizer"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
}

void draw() {
  updateInstructions();
  pushMatrix();
  translate(-width*wMult, 0);

  //IF THERE ARE ACTIVE VOICES...
  if (howManyNow > 0) {
    boolean hasRemoved = false;
    //ITERATE COUNTERS FOR EACH VOICE
    for (int i = howManyNow-1; i >=0; i--) {
      Voice thisVoice = (Voice)voices.get(i);
      int duration = thisVoice.duration;
      int lifespan = thisVoice.lifespan;
      if (lifespan > duration || manualKill) {
        //KILL THE VOICE & START UP NEW ONES
        voices.remove(i);
        hasRemoved = true;
        voiceRoster[thisVoice.voiceIndex] = false;
        howManyNow--;
        manualKill = false;
      }
      //ITERATE COUNTER FOR EACH VOICE
      else thisVoice.lifespan++;
    }
    if(hasRemoved)
       cueVoices();
  }
  else cueVoices();


  //println( "HOW MANY VOICES? " + voices.size() );

  float beat = 0;

  //RUN EACH ACTIVE VOICE
  for (int i = 0; i < howManyNow; i++) {
    Voice thisVoice = (Voice)voices.get(i);
    //println("VOICE: " + i);
    thisVoice.run();
  }

  x++;

  if (x > width*(wMult+1)) {
    wMult++;
    println("WIDTH MULTIPLIER: " + wMult);
    background(bgColor);
  }
  popMatrix();
}

void updateInstructions() {
  fill(10);
  noStroke();
  rect(0, 0, width, 100);
  fill(colorMax);
  text("ENTER: Manual \t SPACE: Modulate Freq \t +/-: No. Voices to Add \t 1: Sine \t 2: Square \t 3: Sawtooth \t 4: Tan \t TAB: Draw Stacked", 20, 20);
  text("MANUAL ON: " + manualOverride + "\t MANUAL KILL: " + manualKill, 20, 40);
  text("WHICH WAVE: " + manWaveIndex + "\t MOD F: " + manModFreq, 20, 60);
  text("NO. VOICES: " + howManyNow + "\t ADD: " + manHowManyToAdd, 20, 80);
}

void cueVoices() {
  if (manualOverride) {
    howManyToAdd = manHowManyToAdd;
    voices = addVoices(howManyToAdd, voices);
    manHowManyToAdd = 1;
  }
  else {
    howManyToAdd = howManyToAdd(howManyNow);
    println("HOW MANY TO ADD? " + howManyToAdd);
    voices = addVoices(howManyToAdd, voices);
  }
  howManyNow = voices.size();

  //println("HOW MANY VOICES? " + howManyNow + "\t" + "HOW MANY TO ADD? " + howManyToAdd);
}

void keyPressed() {
  if (key == ENTER) manualOverride = !manualOverride;
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

