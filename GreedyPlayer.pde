class GreedyPlayer extends Player {
  Cell[] candidates;
  
  GreedyPlayer(int me, Board board) {
    super(me, board);
    candidates = new Cell[board.rows * board.cols];
  }
  
  void play() {
    int n = 0;
    int maxGrains = 0;
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        Cell cell = board.cells[r][c];
        if (cell.owner == me && cell.grains > maxGrains) {
          n = 0;
          maxGrains = cell.grains;
        }
        if (cell.grains == maxGrains && (maxGrains == 0 || cell.owner == me)) {
          candidates[n++] = cell;
        }
      }
    }
    Cell choice = candidates[int(random(n))];
    board.play(me, choice);
  }
}