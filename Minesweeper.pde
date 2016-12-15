

import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

private int tnt = 45;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //declare and initialize buttons
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r ++)
    {
        for(int c = 0; c < NUM_COLS; c ++)
        {
            buttons[r][c] = new MSButton(r,c);
        }
    }
    setBombs();
}
public void setBombs()
{
    for(int i =0; i < tnt; i ++)
    {
   int row = (int)(Math.random()*20);
   int col = (int)(Math.random()*20);
   if(!bombs.contains(buttons[row][col]))
   {
    bombs.add(buttons[row][col]);
   }
   else { i --;}
   }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{

    for(int r = 0; r < NUM_ROWS; r ++)
    {
        for(int c = 0; c < NUM_COLS; c ++)
        {
            if(!bombs.contains(buttons[r][c]) && buttons[r][c].isClicked() == false)
            {
              return false;
            }
        }
    }

    return true;
}
public void displayLosingMessage()
{
        for(int r = 0; r < NUM_ROWS; r ++)
    {
        for(int c = 0; c < NUM_COLS; c ++)
        {
            if(bombs.contains(buttons[r][c]) && buttons[r][c].isClicked() == true )
            {

             buttons[10][6].setLabel("Y");
             buttons[10][7].setLabel("O");
             buttons[10][8].setLabel("U");
             buttons[10][10].setLabel("L");
             buttons[10][11].setLabel("O");
             buttons[10][12].setLabel("S");
             buttons[10][13].setLabel("E");
             
            }
        }
    }
}
public void displayWinningMessage()
{
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("I");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
    noLoop();
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if(mouseButton == LEFT && buttons[r][c].isMarked() == false)
        {

        clicked = true;
        }
        if(mouseButton == RIGHT && buttons[r][c].isClicked()  == false)
        {
            marked = !marked;
        }
        else if (bombs.contains(this))
        {
            displayLosingMessage();
             for(int r = 0; r < NUM_ROWS; r ++)
          {
                for(int c = 0; c < NUM_COLS; c ++)
              {
            if(bombs.contains(buttons[r][c]))
            {
              buttons[r][c].clicked = true;

            }
               }
           }
           //noLoop();
        }
        else if(countBombs(r,c) > 0)
        {
            setLabel(""+countBombs(r,c));
        }
        else 
        {
            for(int nr = -1; nr < 2; nr ++)
            {
                for(int nc = -1; nc<2; nc ++)
                {
                    if(isValid(r+nr, c+nc) && buttons[r+nr][c+nc].clicked == false)
                    {
                        buttons[r+nr][c+nc].mousePressed();
                    }
                }
            }

        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r >=0&& r< NUM_ROWS && c>=0 && c < NUM_COLS)
        {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int tr = -1; tr <2; tr++)
        {
            for(int tc = -1; tc < 2; tc++)
            {
                if(isValid(row+tr,col+tc) && bombs.contains(buttons[row+tr][col+tc]))
                {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}