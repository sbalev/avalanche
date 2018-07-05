class Board {
  int rows, cols;
  int x, y;
  int cellSize;
  Cell[][] cells;
  // for gameOver
  boolean[] o;
  // remember last move
  Cell[] last;
  
  Board(int rows, int cols, int x, int y, int cellSize) {
    this.rows = rows;
    this.cols = cols;
    this.x = x;
    this.y = y;
    this.cellSize = cellSize;
    cells = new Cell[rows][cols];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        cells[r][c] = new Cell(this, r, c);
      }
    }
    o = new boolean[2];
    last = new Cell[2];
  }
  
  void draw(float factor) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        cells[r][c].draw(factor);
      }
    }
  }
  
  void topple() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        cells[r][c].topple();
      }
    }
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        cells[r][c].update();
      }
    }
  }
  
  boolean isStable() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (cells[r][c].grains >= 4) {
          return false;
        }
      }
    }
    return true;
  }
  
  boolean gameOver() {
    o[0] = o[1] = false;
    int totalGrains = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        Cell cell = cells[r][c];
        if (cell.grains > 0) {
          o[cell.owner] = true;
          totalGrains += cell.grains;
        }
      }
    }
    return totalGrains > 1 && o[0] != o[1];
  }
  
  
  boolean choiceXY(int cx, int cy, int player) {
    int r = (cy - y) / cellSize;
    if (r < 0 || r >= rows) return false;
    int c = (cx - x) / cellSize;
    if (c < 0 || c >= cols) return false;
    
    int t = (cy - y) % cellSize;
    if (t < cellSize / 6 || t > 5 * cellSize / 6) return false;
    t = (cx - x) % cellSize;
    if (t < cellSize / 6 || t > 5 * cellSize / 6) return false;
    
    if (cells[r][c].grains == 0 || cells[r][c].owner == player) {
      play(player, cells[r][c]);
      return true;
    }
    return false;
  }
  
  void play(int player, Cell cell) {
    cell.grains++;
    cell.owner = player;
    last[player] = cell;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        cells[r][c].toppled = false;
      }
    }
  }
}