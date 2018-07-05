int[] xSand = { 1, 0, -1, 0, 0, 1, -1, -1, 1};
int[] ySand = { 0, -1, 0, 1, 0, -1, -1, 1, 1};

class Cell {
  Board board;
  int row, col;
  int grains;
  int newGrains;
  int owner;
  boolean toppled;

  Cell(Board board, int row, int col) {
    this.board = board;
    this.row = row;
    this.col = col;
    grains = 0;
    owner = 0;
    toppled = false;
  }

  void draw(float factor) {
    float x = board.x + (0.5 + col) * board.cellSize;
    float y = board.y + (0.5 + row) * board.cellSize;
    float size = 2.0 * board.cellSize / 3;
    if (grains >= 4) {
      size += factor * board.cellSize / 3;
    }
    noStroke();
    rectMode(CENTER);
    
    // border if toppled
    if (toppled) {
      fill(192);
      rect(x, y, board.cellSize, board.cellSize);
    }
    
    if (grains == 0) {
      fill(0);
    } else if (owner == 0) {
      fill(128 + grains * 32, 0, 0);
    } else {
      fill(0, 0, 128 + grains * 32);
    }
    rect(x, y, size, size);
    
    // border if last
    if (this == board.last[0] || this == board.last[1]) {
      if (this == board.last[0]) {
        stroke(255, 0, 0);
      } else {
        stroke(0, 0, 255);
      }
      noFill();
      rect(x, y, size + 3, size + 3);
    }

    // grains
    noStroke();
    float s = size / 3;
    fill(255, 255, 0);
    ellipseMode(CENTER);
    for (int g = 0; g < grains; g++) {
      ellipse(x + s * xSand[g], y + s * ySand[g], s, s);
    }
  }

  void topple() {
    if (grains >= 4) {
      grains -= 4;
      for (int i = 0; i < 4; i++) {
        Cell nbr = neighbor(i);
        if (nbr != null) {
          nbr.newGrains++;
          nbr.owner = owner;
        }
      }
      toppled = true;
    }
  }


  void update() {
    grains += newGrains;
    newGrains = 0;
  }

  Cell neighbor(int i) {
    if (i < 0 || i > 3) return null;
    int r = row + ySand[i];
    if (r < 0 || r >= board.rows) return null;
    int c = col + xSand[i];
    if (c < 0 || c >= board.cols) return null;
    return board.cells[r][c];
  }
}