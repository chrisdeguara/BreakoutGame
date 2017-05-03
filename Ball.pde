class Ball
{
  float x,y,px,py,vx,vy;
  int radius = 15;
  
  public Ball(int x, int y, int vx, int vy)
  {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  void draw()
  {
    fill(0xFFFFFFFF);
    stroke(0);
    strokeWeight(2);
    ellipse(x,y,radius*2, radius*2);
    noStroke();
  }
  
  void update()
  {
    px = x;
    py = y;
    x += vx;
    y += vy;
    
    //check with screen edges  
    if (x + radius >= width || x - radius < 0)
    {
      vx = -vx;
      x += vx*2;
      y += vy;
    }   
    //Ball rebounds on top
    if (y - radius < 0)
    {
      vy = -vy;
      x += vx;            
      y += vy*2;
    }
  }
  
  boolean pointTest(float x1,float y1,int x2,int y2)
  {
    if (dist(x1,y1,x2,y2) < radius)
    {
      return true;
    } else
    {
      return false;
    }
  }
  
  boolean rectTest(float x, float y, int rx1, int ry1, int rx2, int ry2)
  {
    if (x >= rx1 && x < rx2 &&
        y >= ry1 && y < ry2)
    {
      return true;
    } else
    {
      return false;
    }
  }
  
  void reflectVelocity(PVector n)
  {
    n.normalize();
    PVector v = new PVector(vx, vy);
    n.mult(2*(n.dot(v)));
    v.sub(n);
    vx = v.x;
    vy = v.y;
        //V-=2*Normal_wall*(Normal_wall.V)
  }
  
  boolean collidedWithBrick(Brick brick)
  {
    if (rectTest(x,y,brick.x,brick.y-radius,brick.x+brick.w,brick.y+brick.h+radius))
    {
      if (py < brick.y)
      {
        println("top");
        reflectVelocity(new PVector(0,-1));
      } else
      {
        println("bottom");
        reflectVelocity(new PVector(0,1));
      }
      return true;
    } else
    if ( rectTest(x,y,brick.x-radius,brick.y,brick.x+brick.w+radius,brick.y+brick.h))
    {
       if (px < brick.x)
      {
        println("left");
        reflectVelocity(new PVector(-1,0));
      } else
      {
        println("right");
        reflectVelocity(new PVector(1,0));
      }
      return true;
    } else
    if (pointTest(x,y,brick.x,brick.y)) //top-left
    {
      reflectVelocity(new PVector(-1,-1));
      return true;
    } else
    if (pointTest(x,y,brick.x+brick.w,brick.y)) //top-right
    {
      reflectVelocity(new PVector(1,-1));
      return true;
    } else
    if (pointTest(x,y,brick.x,brick.y+brick.h)) //bottom-left
    {
      reflectVelocity(new PVector(-1,1));
      return true;
    } else
    if (pointTest(x,y,brick.x+brick.w,brick.y+brick.h)) //bottom-right
    {
      reflectVelocity(new PVector(1,1));
      return true;
    } else
    {
      return false;
    }
  }  
  
  void resetBall(Ball b)
  {
    //Before firing keep ball in the middle of the paddle
    b.x = paddle.x+(paddle.w/2);
    b.y = height-paddle.h-radius;
  }
}
