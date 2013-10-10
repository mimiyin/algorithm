ArrayList addVoices(int howManyToAdd, ArrayList voices) {
  //Create voices
  // Store values for color, whether to modulate frequency, duration, duration counter and curve type
  for (int i = 0; i < howManyToAdd; i++) {
    for (int j = 0; j < voiceRoster.length; j++) {
      boolean isOff = !voiceRoster[j];
      if (isOff) {
        voiceRoster[j] = true;
        voices.add(new Voice(j));
      }
    }
  }
  return voices;
}


class Voice {
  int voiceIndex = 0;
  int colorIndex = 0;
  color strokeColor = color(100, 180, 180, 50);
  float modFreq = -1;
  int waveIndex = 1;
  Class<?> newWave;
  SineWave newSine;
  TanWave newTan;
  SquareWave newSquare;
  SawTooth newSaw;
  int duration = 1000;
  int lifespan = 0;  
  int counter = 0;
  float beat = 0;
  float voiceYAnchor = height/(voicesMax+1);

  int pitch = 32;
  int [] pitches = { 96, 84, 72, 64, 32 };

  Voice(int index) {

    voiceIndex = index;
    pitch = pitches[int(random(index))];

    println("NEW!!! " + voiceIndex + "\tPITCH: " + pitch);

    //Select Color
    colorIndex = pickOne(colorsMax, colorsTH);
    int hueValue = int(colorIndex*colorMax/voicesMax);
    strokeColor = color(hueValue, 180, 180, 50);
    //strokeColor = color(0, 0, 100, 100);

    //Modulate Frequency?
    modFreq = random(0, 1);
    if (manualOverride) {
      if (manModFreq) modFreq = 1;
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
    duration = int(random(500, 1000));


    //println("COLOR: " + colorIndex + "\t" + "MOD FREQ: " + modFreq + "\t" + "DURATION: " + duration + "\t" + "WHICH CURVE: " + waveIndex);
  }

  void run() {
    counter++;
    //println("VOICE: " + voiceIndex + "\tCOUNTER: " + counter + "\tBEAT: " + beat);
    int voiceY = int((voiceYAnchor * voiceIndex) + voiceYAnchor + 10);

    if ( counter >= beat) {
      for(int i = 0; i < beat; i++) {
        myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
      } 
      switch(waveIndex) {
      case 1:
        beat = newSine.run(); 
        break;
      case 2:
        beat = newSquare.run(); 
        break;
      case 3:
        beat = newSaw.run(); 
        break;
      case 4:
        beat = newTan.run();
        break;
      }
      if (beat >= 0)
        beat += 30;
      else
        beat -= 30;
      counter = 0;
    }

    if ( counter == 0 && beat > 0) {
      fill(100);
      rect(x, voiceY, 10, 20);
      myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
    }
  }
}

