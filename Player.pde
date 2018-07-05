abstract class Player {
  int me;
  Board board;
  
  Player(int me, Board board) {
    this.me = me;
    this.board = board;
  }
  
  abstract void play();
}