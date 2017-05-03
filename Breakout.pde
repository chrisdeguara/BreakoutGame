//Import minim sound library
import ddf.minim.*;
import java.util.Iterator;

//Global variables
Brick lastCollision;
Ball ball;
ArrayList bricks = new ArrayList();
Brick paddle;
PFont font; 
int scoreCount; 
boolean ballMoving;
boolean stillInMenu;
boolean isMale;
boolean genderSelected;
boolean colorSelected;
boolean gameStarted;
boolean setupReady;
boolean firstTimeSetup;
boolean gameWon;
boolean femalePenalty;
boolean bgMusicPlaying;
boolean movingLeft;
boolean movingRight;
boolean showMessage;
boolean isMute;
boolean hasFallenPlayed;
PImage maleFullBody;
PImage femaleFullBody;
PImage maleFace;
PImage femaleFace;
PImage maleBGImage;
PImage femaleBGImage;
color maleBG = 0xFF9AC0CD;
color femaleBG = 0xFFFFB6C1;
color paddleColor;
Menu menu;
Minim minim;
AudioPlayer bgMusicMen;
AudioPlayer bgMusicWomen;
AudioSample brickHitMen;
AudioSample brickHitWomen;
AudioSample falling;

void setup()
{
  size(700,500);
  ballMoving = false;
  stillInMenu = true;
  isMale = true;
  genderSelected = false;
  colorSelected = false;
  gameStarted = false;
  setupReady = false;
  firstTimeSetup = true;
  gameWon = false;
  femalePenalty = false;
  bgMusicPlaying = false;
  movingLeft = false;
  movingRight = false;
  showMessage = false;
  isMute = false;
  hasFallenPlayed = false;
  menu = new Menu(true, color(0xFFFFFF00));
  font = loadFont("fonts/Neuropol.vlw");
  textFont(font);
  textSize(18);
  scoreCount = 0;
  //Load images
  maleFullBody = loadImage("images/maleFull.png");
  femaleFullBody = loadImage("images/femaleFull.png");
  maleFace = loadImage("images/maleFace.png");
  femaleFace = loadImage("images/femaleFace.png");
  maleBGImage = loadImage("images/solar_system.jpg");
  femaleBGImage = loadImage("images/scenery.jpg");
  //Intantiate minim library
  minim = new Minim(this);
  //Load sounds
  bgMusicMen = minim.loadFile("sounds/distant_system_equidistant.mp3");
  bgMusicWomen = minim.loadFile("sounds/zero_7_destiny.mp3");
  brickHitMen = minim.loadSample("sounds/shot.wav");
  brickHitWomen = minim.loadSample("sounds/hit.wav");
  falling = minim.loadSample("sounds/dropped.wav");
}

void handleInput()
{ 
  //Handle keyboard left and right controls
  if (movingLeft && paddle.x > 0)
  {
    paddle.x -= 12;
  }
  if (movingRight && paddle.x < width-paddle.w)
  {
    paddle.x += 12;
  }
}

void updateScene()
{
  if (ballMoving == true)
  {    
    ball.update();
    //HACK: to avoid getting the ball stuck within the paddle. This can happen
    //if, after a collision, the paddle moves again into the ball, causing the
    //ball to invert velocities again, ending up with the ball bouncing within
    //the paddle. To overcome this, we keep track of the last collision, and if
    //we collided with the same thing on the next frame, then just ignore it by
    //resetting the velocities to the previous values just before collidedWithBrick
    //modified the velocities.
    float pvx = ball.vx;
    float pvy = ball.vy;
    if (ball.collidedWithBrick(paddle))
    {
      if (lastCollision == paddle)
      {
        //reset velocities as if nothing happened
        ball.vx = pvx;
        ball.vy = pvy;
      } 
      else
      {
        lastCollision = paddle;
      }
    } 
    else
    {
      lastCollision = null;
    }
    
    //check with all the bricks
    Iterator iter = bricks.iterator();
    while (iter.hasNext())
    {
      Brick brick = (Brick)iter.next();
      if (ball.collidedWithBrick(brick))
      {
        if (isMale)
        {
          brickHitMen.trigger();  //Make men sound effect (scifi)
        }
        else
        {
          brickHitWomen.trigger();  //Make women sound effect (not scifi)
        }
        iter.remove();  //Remove hit brick
        scoreCount++;  //Increase score when brick is hit and removed
        break; //only remove one
      }
    }
  }
}

void drawScene()
{ 
 //Show background depending on player's gender
 if (isMale)
 { 
    background(maleBGImage);
 }
 else
 {
   background(femaleBGImage);
 }
  
  if (!ballMoving)
  {
    //Double text with slightly different positions to get a shadow effect on text
    fill(0);
    text("Press space to launch the ball", 223, 352);
    fill(0xFFFFFFFF);
    text("Press space to launch the ball", 225, 350);
  }
  ball.draw();
  stroke(0);
  strokeWeight(2);
  paddle.draw();
  noStroke();
  
  stroke(0);
  strokeWeight(5);
  for (int i = 0; i < bricks.size(); i++)
  {
    Brick brick = (Brick)bricks.get(i);
    brick.draw();
  }
  noStroke();
}

//Show the current score
void showScore() 
{
  fill(0xFFFFFFFF);
  text("Score: " + scoreCount, 10, 30);
  text("M: Toggle Music", 150, 30);
}

//Check if ball has been dropped
void checkGameOver()
{
  if (ball.y > height + ball.radius)
  {    
    //Score decreases by 3 if user is female
    if (!isMale && scoreCount > 3 && !femalePenalty)
    {
      scoreCount-=3;
      femalePenalty = true;
    }
    //Stop ball from moving until space bar is pressed
    if (ballMoving)
    {
      ballMoving = false;
    }
    //Show relative top message
    if (!showMessage)
    {
      showMessage = true;
    }
  } 
  
  if (showMessage)
  {
      fill(0xFFFFFFFF);
      //Check if female has more than 3 points
      if (femalePenalty)
      {
        text("You dropped the ball and lost 3 points! Press space to continue",10,70);
        
        //Play falled sound only once. This state is reset as soon as space is pressed
        if (!hasFallenPlayed)
        {
          falling.trigger();
          hasFallenPlayed = true;
        }
      }
      else
      {
        if (isMale)
        {
          text("You Lost! Press space to start again", 10, 70);
          if (!hasFallenPlayed)
          {
            falling.trigger();
            hasFallenPlayed = true;
          }
        }
        else
        {
          text("You dropped the ball! Press space to continue",10,70);
          if (!hasFallenPlayed) 
          {
            falling.trigger();
            hasFallenPlayed = true;
          }
        }
      }
  }
}

//Check if game is won by checking if there are no bricks left
void checkGameWon()
{
  if (bricks.size() == 0)
  {
    fill(0xFFFFFFFF);
    text("You Won! Press space to play again", 10, 70);
    ballMoving = false;
    gameWon = true;
  }
}

//Check mouse click and store selected gender
void mousePressed()
{
  if (genderSelected == false)
  { 
    if (mouseX <= width/2)
    {
      isMale = true;
      genderSelected = true;
    } else
    {
      isMale = false;
      genderSelected = true;
    }
  }
  else if (genderSelected == true && colorSelected == false)
  {
    colorSelected = true;
    paddleColor = get(mouseX,mouseY);
    //Proceed to game
    stillInMenu = false;
  }
}

//Handle paddle movement on key pressed and check if space is pressed to start new round
void keyPressed() 
{
  if (key == 'm' || key == 'M')
  {
    //Toggle music
    if (!isMute)
    {
      if (isMale)
      {
        bgMusicMen.pause();
      }
      else
      {
        bgMusicWomen.pause();
      }
      isMute = true;
    }
    else
    {
      if (isMale)
      {
        bgMusicMen.play();
      }
      else
      {
        bgMusicWomen.play();
      }
      isMute = false;
    }
  }
  if (keyCode == LEFT)
  {
    movingLeft = true;
  }
  if (keyCode == RIGHT)
  {
    movingRight = true;
  }
  
  if (!ballMoving && keyCode == ' ') 
  {
    if (femalePenalty)
    {
      femalePenalty = false;
    }
    
    if (!ballMoving)
    {
      ballMoving = true;
    }
    
    if (showMessage)
    {
      showMessage = false;
    }
      
    //Score and bricks are reset only if player is male or the game is won
    if (isMale || gameWon)
    {
      scoreCount = 0;
      setupReady = false;
      bricks.clear();
    }
    
    //Reset has fallen sound
    if (hasFallenPlayed = true)
    {
      hasFallenPlayed = false;
    }
  }
}

//Handle paddle movement booleans on release
void keyReleased()
{
  if (keyCode == LEFT)
  {
    movingLeft = false;
  }
  if (keyCode == RIGHT)
  {
    movingRight = false;
  }
}

//Show Avatar depending on user gender
void showAvatar()
{ 
  if (isMale)
  {
    image(maleFace,width-maleFace.width,0);
  }
  else
  {
    image(femaleFace,width-femaleFace.width,0);
  }
}

void generateLevel()
{
  //create a simple level
  for (int i = 0; i < 7; i++)
  { 
    bricks.add(new Brick(i*100,80,100,30, color(0xFF009999)));
  }
  for (int i = 0; i < 6; i++)
  {
    bricks.add(new Brick(i*100+50,110,100,30, color(0xFF1240AB)));
  }
  for (int i = 0; i < 5; i++)
  {
    bricks.add(new Brick(i*100+100,140,100,30, color(0xFF00CC00)));
  }
  for (int i = 0; i < 4; i++)
  {
    bricks.add(new Brick(i*100+150,170,100,30, color(0xFFFF7400)));
  }
  for (int i = 0; i < 3; i++)
  {
    bricks.add(new Brick(i*100+200,200,100,30, color(0xFF006363)));
  }
}

//Close minim library on game close
void stop()
{
 //always close Minim audio classes when you are finished with them
 bgMusicMen.close();
 minim.stop();

 super.stop();
}

void draw()
{
  if (stillInMenu == true && genderSelected == false)
  {
    //show menu
    menu.showGenderSelection(maleBG, femaleBG);
  } 
  else if (stillInMenu == true && genderSelected == true)
  {
    if (isMale)
    {
      menu.showColorWheel(maleBG);
      image(maleFullBody,80,60);
    } 
    else
    {
      menu.showColorWheel(femaleBG);
      image(femaleFullBody,80,60);
    }
    
  } 
  else
  {
    //Run setup with custom configuration only once
    if (setupReady == false)
    {
      //Only create the paddle the first time
      if (firstTimeSetup)
      {
        ball = new Ball(width/2, height/2, 5, 3);
        //Create paddle with selected paddle color
        paddle = new Brick(width/2, height-30,100,30, paddleColor);
        firstTimeSetup = false;
      }
      
      generateLevel();
      ball.resetBall(ball);
      
      //If game has been won reset it back to not won since user has chosen to start playing again
      if (gameWon)
      {
        gameWon = false;
      }
      stroke(0xFFFFFFFF);
      setupReady = true;
    }
    else
    {
      //Start playing bg music only once
      if (!bgMusicPlaying)
      {
        if (isMale)
        {
          bgMusicMen.play();
          bgMusicMen.loop();
        }
        else
        {
          bgMusicWomen.play();
          bgMusicWomen.loop();
        }
        
        bgMusicPlaying = true; 
      }
      if (!ballMoving)
      {
        ball.resetBall(ball);
      }
      handleInput();  
      updateScene();
      drawScene();
      showScore();
      checkGameOver();
      checkGameWon(); 
      showAvatar();
    }
  }
}
