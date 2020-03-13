import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r,c);

    //your code to initialize buttons goes here
    
    
    
    setMines();
}
public void setMines()
{
    while (mines.size() < NUM_BOMBS){

    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c]))
        mines.add(buttons[r][c]);
    }
    //your code
}
public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
    }
}
public boolean isLoss()
{
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
          if(mines.contains(buttons[r][c])){ 
            if(buttons[r][c].clicked)
                return true;
            return false;
        }
    return false;
}

public boolean isWon()
{
    
    int count = 0;
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
        if(!mines.contains(buttons[r][c]))
            if(buttons[r][c].clicked)
            count++;;
    if(count == (NUM_ROWS*NUM_COLS) - NUM_BOMBS)
        return true;
    return false;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            if(mines.contains(buttons[r][c]))
                buttons[r][c].clicked = true;
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[10][7].setLabel("L");
    buttons[10][8].setLabel("O");
    buttons[10][9].setLabel("S");
    buttons[10][10].setLabel("E");
    buttons[10][11].setLabel("!");
}
public void displayWinningMessage()
{
    buttons[7][6].setLabel("C");
    buttons[7][7].setLabel("O");
    buttons[7][8].setLabel("N");
    buttons[7][9].setLabel("G");
    buttons[7][10].setLabel("R");
    buttons[7][11].setLabel("A");
    buttons[7][12].setLabel("T");
    buttons[7][13].setLabel("S");
    buttons[9][8].setLabel("Y");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("U");
    buttons[11][8].setLabel("W");
    buttons[11][9].setLabel("I");
    buttons[11][10].setLabel("N");
}
public boolean isValid(int r, int c)
{
    //your code here
  if(r<NUM_ROWS && r>= 0 && c < NUM_COLS && c >= 0)
    return true;
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int c = col-1; c <= col+1; c++)
        for(int r = row-1; r <= row+1; r++)
            if(isValid(r,c) == true && mines.contains(buttons[r][c]))
                numMines++;
    if(mines.contains(buttons[row][col]))
        numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(isWon() == true)
            return;
        if(isLoss() == true)
            return;
        clicked = true;
        //your code here
        if(mouseButton == RIGHT){
            flagged = !flagged;
            if(flagged == false)
                clicked = false;
        }else if(mines.contains(this)){
            displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0) 
            setLabel("" + countMines(myRow, myCol));
        else{
            if(isValid(myRow, myCol-1) && !buttons[myRow][myCol-1].clicked)
                buttons[myRow][myCol-1].mousePressed();
            if(isValid(myRow, myCol+1) && !buttons[myRow][myCol+1].clicked)
                buttons[myRow][myCol+1].mousePressed();
            if(isValid(myRow+1, myCol-1) && !buttons[myRow+1][myCol-1].clicked)
                buttons[myRow+1][myCol-1].mousePressed();
            if(isValid(myRow-1, myCol-1) && !buttons[myRow-1][myCol-1].clicked)
                buttons[myRow-1][myCol-1].mousePressed();
            if(isValid(myRow+1, myCol+1) && !buttons[myRow+1][myCol+1].clicked)
                buttons[myRow+1][myCol+1].mousePressed();
            if(isValid(myRow-1, myCol+1) && !buttons[myRow-1][myCol+1].clicked)
                buttons[myRow-1][myCol+1].mousePressed();
            if(isValid(myRow+1, myCol) && !buttons[myRow+1][myCol].clicked)
                buttons[myRow+1][myCol].mousePressed();
            if(isValid(myRow-1, myCol) && !buttons[myRow-1][myCol].clicked)
                buttons[myRow-1][myCol].mousePressed();

        }
       
    }
    public void draw () 
    {    
        if (flagged)
            fill(148,0,211);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill(225,225,0);
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
