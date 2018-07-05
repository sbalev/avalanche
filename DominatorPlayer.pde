class DominatorPlayer extends Player {
  boolean[][] dominated;
  Board copyBoard;
  Cell[] candidates;

  DominatorPlayer(int me, Board board) {
    super(me, board);
    dominated = new boolean[board.rows][board.cols];
    copyBoard = new Board(board.rows, board.cols, 0, 0, 0);
    candidates = new Cell[board.rows * board.cols];
  }

  void play() {
    int maxScore = 0;
    int n = 0;
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        int s = score(r, c);
        if (s > maxScore) {
          maxScore = s;
          n = 0;
        }
        if (s == maxScore) {
          candidates[n++] = board.cells[r][c];
        }
      }
    }
    
    // take only candidates with max grains
    //int maxGrains = 0;
    //for (int i = 0; i < n; i++) {
    //  if (candidates[i].grains > maxGrains) {
    //    maxGrains = candidates[i].grains;
    //  }
    //}
    //int oldN = n;
    //n = 0;
    //for (int i = 0; i < oldN; i++) {
    //  if (candidates[i].grains == maxGrains) {
    //    candidates[n++] = candidates[i];
    //  }
    //}

    Cell choice = candidates[int(random(n))];
    board.play(me, choice);
  }

  boolean isDominated(Cell cell) {
    for (int i = 0; i < 4; i++) {
      Cell nbr = cell.neighbor(i);
      if (nbr != null && nbr.grains >= cell.grains && nbr.owner != cell.owner) {
        return true;
      }
    }
    return false;
  }

  int score(Board board) {
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        dominated[r][c] = false;
      }
    }
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        Cell cell = board.cells[r][c];
        if (cell.owner == me && cell.grains > 0 && !isDominated(cell)) {
          // check if it works better
          dominated[r][c] = true;
          for (int i = 0; i < 4; i++) {
            Cell nbr = cell.neighbor(i);
            if (nbr != null && (nbr.owner != cell.owner || nbr.grains == 0)) {
              dominated[nbr.row][nbr.col] = true;
            }
          }
        }
      }
    }
    int score = 0;
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        if (dominated[r][c])  score++;
      }
    }
    return score;
  }

  int score(int r, int c) {
    Cell cell = board.cells[r][c];
    int s = -1;
    if (cell.grains > 0 && cell.owner != me) return s;
    cell.grains++;
    cell.owner = me;
    if (cell.grains < 4) {
      s = score(board);
    } else {
      freshCopy();
      do {
        copyBoard.topple();
      } while (!copyBoard.isStable());
      s = score(copyBoard);
    }
    cell.grains--;
    return s;
  }

  void freshCopy() {
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        copyBoard.cells[r][c].grains = board.cells[r][c].grains;
        copyBoard.cells[r][c].owner = board.cells[r][c].owner;
      }
    }
  }
}