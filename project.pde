import processing.serial.*;

import java.awt.Point;
import javax.swing.*;
import java.util.Random;

static final int EMPTY = 0;
static final int HEAD = 1;
static final int TAIL = 2;
static final int FOOD = 3;
static final int SIZE = 25;

Serial port;
ArrayList<Point> snake;
int[][] board;
boolean up;
boolean right;
boolean down;
boolean left;

void setup() {
 
 String portName = Serial.list()[0];
 port = new Serial(this, portName, 9600); 
  
 size(550, 550);
 
 up=false;
 right=true;
 down=false;
 left=false;
 
 snake = new ArrayList<Point>();
 snake.add(new Point(5,5));
 snake.add(new Point(5,4));
 
 board = new int[20][20];
 board[snake.get(0).x][snake.get(0).y] = HEAD;
 board[snake.get(1).x][snake.get(1).y] = TAIL;
 board[3][3] = FOOD;
}

void draw() {
 
 String dir = readDirection();
 processMovement(dir);
 move();
 for(int i = 0; i<board.length; i++){
    for(int j = 0; j<board.length; j++){

      if(board[i][j] == HEAD){
        
        fill(255,0,0);
        stroke(0,0,0); 
        rect(i * SIZE, j * SIZE, SIZE, SIZE);
        
      } else if(board[i][j] == TAIL){
        
        fill(0,0,255);
        stroke(0,0,0);
        rect(i * SIZE, j * SIZE, SIZE, SIZE);
        
      } else if(board[i][j] == FOOD){
        
        fill(0,255, 50);
        stroke(0,0,0);
        rect(i * SIZE, j * SIZE, SIZE, SIZE);
        
      } else if(board[i][j] == EMPTY){
              
        fill(255,255,255);
        stroke(0,0,0);
        rect(i * SIZE, j * SIZE, SIZE, SIZE);
      }
    }
 }
 
 delay(300);
}

String readDirection(){
  
  String dir = "";
  while (port.available() > 0) {
    int inByte = port.read();
    dir += (char)inByte;
  }
  
  if(dir != "")
    System.out.println(dir);
  return dir;
}

void processMovement(String dir){
  if (dir.toLowerCase().trim().contains("u") && down == false) {
    up = true;
    left = right = false;
    
  } else if (dir.toLowerCase().trim().contains("d") && up == false) {
    down = true;
    left = right = false;
    
  } else if (dir.toLowerCase().trim().contains("l") && right == false) {
    left = true;
    up = down = false;
    
  } else if (dir.toLowerCase().trim().contains("r") && left == false) {
    right = true;
    up = down = false;
  }
}

void move(){
 
  for(int i=snake.size()-1; i>=1; i--){
    snake.get(i).x = snake.get(i-1).x;
    snake.get(i).y = snake.get(i-1).y;
  }
    
  if(up == true){
    snake.get(0).y = snake.get(0).y - 1;   
  } else if(down == true){
    snake.get(0).y = snake.get(0).y + 1; 
  } else if(left == true){
    snake.get(0).x = snake.get(0).x - 1;
  } else {
    snake.get(0).x = snake.get(0).x + 1;  
  }
  
  //collision with snake
  for(int i=1;i<snake.size();i++){
     if(snake.get(0).x == snake.get(i).x && snake.get(0).y == snake.get(i).y){
         showMessage();
     }
  }
  
  if(snake.get(0).x>=0 && snake.get(0).x <board.length && snake.get(0).y>=0 && snake.get(0).y <board.length){
    if(board[snake.get(0).x][snake.get(0).y] == FOOD){
       addFood();
    }
  } else {
    showMessage(); 
  }
  
  updateBoard();
}

void keyPressed() {
  if (keyCode == UP && down == false) {
    up = true;
    left = right = false;
    
  } else if (keyCode == DOWN && up == false) {
    down = true;
    left = right = false;
    
  } else if (keyCode ==  LEFT && right == false) {
    left = true;
    up = down = false;
    
  } else if (keyCode == RIGHT && left == false) {
    right = true;
    up = down = false;
  }
}

void updateBoard(){
  
  for(int i=0; i<board.length; i++)
    for(int j=0; j<board.length; j++)
      if(board[i][j] != FOOD)
        board[i][j] = 0;
  
  board[snake.get(0).x][snake.get(0).y] = HEAD;
  for(int i=1; i<snake.size(); i++)
    board[snake.get(i).x][snake.get(i).y] = TAIL;
}

void addFood(){
   int x, y;
   Random random = new Random();
   
   do{
     x=random.nextInt(20);
     y=random.nextInt(20);
   }while(board[x][y] != EMPTY);
   board[x][y] = FOOD;
   enlarge();
}

void enlarge(){
    Point last = snake.get(snake.size()-1);
    
    if(last.y-1 >=0 && board[last.x][last.y-1] == EMPTY){
      //up
      snake.add(new Point(last.x, last.y-1));
    } else if(last.y+1 < board.length && board[last.x][last.y+1] == EMPTY){
      //down
      snake.add(new Point(last.x, last.y+1));
    } else if(last.x-1 >= 0 && board[last.x-1][last.y] == EMPTY){
      //left
      snake.add(new Point(last.x-1, last.y));
    } else if(last.x+1 < board.length && board[last.x+1][last.y] == EMPTY){
      //right
      snake.add(new Point(last.x+1, last.y));
    }
}

void showMessage(){
   int dialogResult = JOptionPane.showConfirmDialog(null, "You crashed! Would you like to replay?", "Game Over", JOptionPane.YES_NO_OPTION);
   if(dialogResult == JOptionPane.YES_OPTION){
     setup();
   } else {
     System.exit(0);
   }
}
