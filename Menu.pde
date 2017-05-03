class Menu
{
  boolean isMale;
  color paddleColor;
  
  public Menu()
  {
    isMale = true;
    paddleColor = color(0xFFFF0000);
  }
  
  public Menu(boolean isMale, color paddleColor)
  {
    this.isMale = isMale;
    this.paddleColor = paddleColor;
  }
  
  //Ask the user to select gender
  void showGenderSelection(color maleBG, color femaleBG)
  { 
    fill(maleBG);
    rect(0,0,width/2,height);
    
    fill(femaleBG);
    rect(width/2,0,width/2,height);
   
    showWelcome();
    
    fill(0xFFFFFFFF);
    text("Select your gender", 10,50);
    
    image(maleFullBody, 80, 60);
    image(femaleFullBody, width/2+120, 55);
  }
  
  void showColorWheel(color bg)
  {
    int SIZE = 400;
    int currentHue = 0;
    int currentSat = 255;
    int currentPie = 4;
    float angle = TWO_PI/12;
    background(bg);
    colorMode(HSB, TWO_PI, 255, 255);
    for (int i=0; i<12; i++) 
    {
      for (int j=1; j<8; j++) 
      {
        fill(angle*i,255,255);
        arc(width/1.5, height/2, SIZE, SIZE, angle*i, angle*(i+1));
      }
    }
    colorMode(RGB);
    fill(0xFFFFFFFF);
    showWelcome();
    text("Select your paddle colour", 10, 50);
  }
  
  void showWelcome()
  {
    fill(0x00000000);
    textSize(24);
    text("Welcome to BREAKOUT!",10,25);
    textSize(18);
    fill(0xFFFFFFFF);
  }
}
