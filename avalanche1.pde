float factor = 1.0;
int turn = 0;
boolean waiting = false;
int moves = 0;

Board board = new Board(5, 5, 0, 0, 120);
Player ia = new DominatorPlayer(1, board);

void setup() {
  size(600, 630);
  // test();
}

void draw() {
  background(255);
  waiting = false;
  board.draw(factor);
  if (factor < 1) {
    factor += 0.01;
  } else if (!board.isStable()) {
    board.topple();
    factor = 0;
  } else if (board.gameOver()) {
    fill(0);
    text("Game over. Moves " + moves, 10, 620);
    noLoop();
  } else if (turn == 1) {
    ia.play();
    if (!board.isStable()) factor = 0;
    turn = 0;
  } else {
    waiting = true;
    fill(0);
    text("Your turn. Moves " + moves, 10, 620);
  }
}

void mousePressed() {
  if (waiting && board.choiceXY(mouseX, mouseY, 0)) {
    factor = 0;
    turn = 1;
    moves++;
  }
}



//void test() {
//  board.cells[2][2].grains = 1;
//  board.draw(0);
//  DominatorPlayer dp = new DominatorPlayer(1, board);
//  textAlign(CENTER, CENTER);
//  stroke(255);
//  for (int r = 0; r < board.rows; r++) {
//    for (int c = 0; c < board.cols; c++) {
//      int s = dp.score(r, c);
//      float x = (0.5 + c) * board.cellSize;
//      float y = (0.5 + r) * board.cellSize;
//      text(s, x, y);
//    }
//  }
//  dp.play();
//}
