class Brick
{
  int x, y, w, h, c;
  
  public Brick(int x, int y, int w, int h, color c)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
  }
  
  public void draw()
  {
    fill(c);
    rect(x, y, w, h);
  }
}
