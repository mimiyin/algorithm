class Wave {
  float x = 0;
  float xFactor = 0.01;
  float yFactor = 50;
  float modFreq = 0;
  float xChange = 1.5;

  Wave() {
  }
}

//Gradual Growth and Decay
class SineWave extends Wave {
  SineWave modulate;
  
  SineWave(float modFreq_) {
    super(); 
    modFreq = modFreq_; 
    if (modFreq > .1) modulate = new SineWave(-1);
    else if (modFreq == -1) xFactor = 0.000001;
    else xFactor = 0.01;
  }

  float run() {
    x+=xChange;
    if (modFreq > .1) xFactor = modulate.run();
    return sin(xFactor*x)*yFactor;
  }
}

// Regular pulses
// Unpredictable pulses
class TanWave extends Wave {

  TanWave(float modFreq_) {
    super();
    modFreq = modFreq_; 
    xFactor = .01;
  }

  float run() {
    x+=xChange;
    if (modFreq > .5) xFactor = random(0, 1);
    return tan(x*xFactor);
  }
}

// Sudden and Sustained Change
class SquareWave extends Wave {
  int counter = 0;
  float hiPeriod = 100;
  float loPeriod = 30;
  boolean high = true;
  SineWave modulateLo;
  SineWave modulateHi;
    
  SquareWave(float modFreq_) {
    super();
    modFreq = modFreq_; 
    if(modFreq > .5) modulateLo = new SineWave(-1);
    if(modFreq > .3) modulateHi = new SineWave(-1);

  }

  float run() {
    counter+=xChange;
    if (high && counter < hiPeriod) x = 50;
    else if (!high && counter < loPeriod) x = -50;
    else {
      high = !high;
      counter = 0;
      if (modFreq > .5) loPeriod = modulateLo.run();
      if (modFreq > .3) hiPeriod = modulateHi.run();
    }
    return x;
  }
}

// Linear Growth, Sudden Extinction
class SawTooth extends Wave {
  float period = 100;
  SineWave modulate;

  SawTooth(float modFreq_) {
    super();
    modFreq = modFreq_; 
    if (modFreq > .3) modulate = new SineWave(-1);
    x = -100; 
  }

  float run() {
    if (x < period) x+=xChange;
    else {
      x = -100;
      if(modFreq > .3) period = modulate.run();
    }

    return x;
  }
}

