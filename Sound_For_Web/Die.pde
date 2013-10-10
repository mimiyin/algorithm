float[] rollDie(int divisions) {
  float [] thresholds = new float[divisions];
  float addOn = 0;

  
   // ROLL DICE TO SEE WHICH VOICES GET WHICH THRESHOLDS
  for(int i = 0; i < divisions; i++) {
    float value = addOn + random(0,1);
    thresholds[i] = value;
    addOn = value;
    // Print out the values all in one line
    print(thresholds[i] + "\t");
    if(i == divisions-1) print("\n");
  }
 
 return thresholds; 
}

int addHowMany(int howManyNow) {
    
  // How many voices can I activate max?
  int numToAdd = constrain(voicesMax - howManyNow, 1, voicesMax);
  println("HOW MANY NOW? " + howManyNow);
  
  numToAdd = pickOne(numToAdd, voicesTH);
  return numToAdd;
}

int pickOne(int maxValue, float[] divvyRange) {
  
  // Pick a number within that range
  float pickANumber = random(0, divvyRange[maxValue-1]);
  
  
  // Load a new array of THs with randomly picked number
  float[] pickOnes = new float[maxValue+1];
  for(int i = 0; i < maxValue; i++) {
    if(i == maxValue-1) pickOnes[i] = pickANumber;
    else pickOnes[i] = divvyRange[i];
  }
  
  // Sort it
  pickOnes = sort(pickOnes);
  int pickedOne = 0;
  
  // The index above pickANumber is the winner
  for (int i = 0; i < maxValue; i++) {
    if (pickOnes[i] == pickANumber) {
      pickedOne = i;
    }
  }
  return pickedOne;
}
