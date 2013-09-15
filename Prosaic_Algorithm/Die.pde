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

int howManyToAdd(int howManyNow) {
    
  // How many voices can I activate max?
  int howManyToAdd = constrain(voicesMax - howManyNow, 1, voicesMax);
  println("HOW MANY NOW? " + howManyNow);
  
  howManyToAdd = pickOne(howManyToAdd, voicesTH) + 1;
  return howManyToAdd;
}

int pickOne(int maxValue, float[] divvyRange) {
  
  // Pick a number within that range
  float pickANumber = random(0, divvyRange[maxValue-1]);
  
  
  // Load a new array of THs with randomly picked number
  float[] pickOne = new float[maxValue+1];
  for(int i = 0; i < maxValue+1; i++) {
    if(i == maxValue) pickOne[i] = pickANumber;
    else pickOne[i] = divvyRange[i];
  }
  
  // Sort it
  pickOne = sort(pickOne);
  int pickedOne = 0;
  
  // The index above pickANumber is the winner
  for (int i = 0; i < maxValue+1; i++) {
    if (pickOne[i] == pickANumber) {
      pickedOne = i;
    }
  }
  return pickedOne;
}
