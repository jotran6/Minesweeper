import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final int NUM_ROWS = 20;
private final int NUM_COLS = 20;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup () {
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    
    // initialize buttons
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            buttons[row][col] = new MSButton(row, col);
        }
    }
    
    // initialize mines
    mines = new ArrayList<MSButton>();
    setMines();
}
public void setMines() {
    int totalMines = -20;
    while (totalMines < NUM_ROWS) {
        int row = (int) random(NUM_ROWS);
        int col = (int) random(NUM_COLS);
        MSButton button = buttons[row][col];
        if (!mines.contains(button)) {
            mines.add(button);
            totalMines++;
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon() {
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (!mines.contains(button) && !button.isClicked()) {
                return false; // if any non-mine button is unclicked, the game is not won
            }
        }
    }
    return true; // if all non-mine buttons are clicked, the game is won
}

public void displayLosingMessage() {
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (mines.contains(button) && !button.isFlagged()) {
                button.setLabel("X"); // reveal all unflagged mines
            }
            button.setClicked(true); // mark all buttons as clicked
        }
    }
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(36);
    text("Game Over", width / 2, height / 2 - 20);
    textSize(24);
    text("Click to restart", width / 2, height / 2 + 20);
}
public void displayWinningMessage() {
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (mines.contains(button)) {
                button.setFlagged(true); // flag all mines
            }
            button.setClicked(true); // mark all buttons as clicked
        }
    }
    textAlign(CENTER, CENTER);
    fill(0, 255, 0);
    textSize(36);
    text("You Win!", width / 2, height / 2 - 20);
    textSize(24);
    text("Click to restart", width / 2, height / 2 + 20);
}
public boolean isValid(int r, int c) {
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}

public int countMines(int row, int col) {
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && mines.contains(buttons[r][c])) {
                numMines++;
            }
        }
    }
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
   public void mousePressed() {
    if (!clicked) {
        if (mouseButton == LEFT) {
            clicked = true;
            if (mines.contains(this)) {
                // clicked on a mine, game over
                displayLosingMessage();
            } else if (isWon()) {
                // all non-mine buttons clicked, game won
                displayWinningMessage();
            } else {
                // update label with number of adjacent mines
                int numMines = countMines(myRow, myCol);
                setLabel(numMines);
                // recursively click all non-mine buttons adjacent to this one
                if (numMines == 0) {
                    for (int i = myRow - 1; i <= myRow + 1; i++) {
                        for (int j = myCol - 1; j <= myCol + 1; j++) {
                            if (isValid(i, j)) {
                                MSButton neighbor = buttons[i][j];
                                if (!neighbor.isFlagged() && !neighbor.clicked) {
                                    neighbor.mousePressed();
                                }
                            }
                        }
                    }
                }
            }
        } else if (mouseButton == RIGHT) {
            flagged = !flagged; // toggle flag status
        }
    }
}
public boolean isClicked() {
  return clicked;
}
public void setClicked(boolean value) {
  clicked = value;
}

public void setFlagged(boolean value) {
  flagged = value;
}
    public void draw () 
    {    
        if (flagged)
            fill(#F39DF7);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill(#88F093);
        else 
            fill(#A7EEFA);

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
