ArrayList addVoices(int howManyToAdd, ArrayList voices) {
  //Create voices
  // Store values for color, whether to modulate frequency, duration, duration counter and curve type
  for (int i = 0; i < howManyToAdd; i++) {
    voices.add(new Voice(i));
  }
  return voices;
}

class Voice {
  int colorIndex = 0;
  color strokeColor = color(100, 180, 180, 50);
  float modFreq = -1;
  int waveIndex = 1;
  SineWave newSine;
  TanWave newTan;
  SquareWave newSquare;
  SawTooth newSaw;
  int duration = 1000;
  int counter = 0;  
  
  Voice(int index) {
    //Select Color
    colorIndex = pickOne(colorsMax, colorsTH);
    int hueValue = int(colorIndex*colorMax/voicesMax);
    strokeColor = color(hueValue, 180, 180, 50);
    //strokeColor = color(0, 0, 100, 100);
    
    //Modulate Frequency?
    modFreq = random(0, 1);
    if (manualOverride) {
      if(manModFreq) modFreq = 1;
      else modFreq = 0;
      }
    
    //Which Curve?
    waveIndex = pickOne(wavesMax, wavesTH);
    if (manualOverride) waveIndex = manWaveIndex;
    
    //Store curve
    switch(waveIndex) {
     case 1:
      newSine = new SineWave(modFreq); 
      break;  
     case 2:
      newSquare = new SquareWave(modFreq); 
      break;  
     case 3:
      newSaw = new SawTooth(modFreq); 
      break;  
     case 4:
      newTan = new TanWave(modFreq); 
      break;     
    }
    
    //Pick a Duration
    duration = int(random(100, 1000));
    
    //Kick off Duration counter for each voice
    counter = 0;

    println("COLOR: " + colorIndex + "\t" + "MOD FREQ: " + modFreq + "\t" + "DURATION: " + duration + "\t" + "WHICH CURVE: " + waveIndex);    
  }
}
