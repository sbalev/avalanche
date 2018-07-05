class RandomGreedyPlayer extends Player {
  Player random, greedy;
  float p;
  
  RandomGreedyPlayer(int me, Board board, float p) {
    super(me, board);
    random = new RandomPlayer(me, board);
    greedy = new GreedyPlayer(me, board);
    this.p = p;
  }
  
  void play() {
    if (random(1) < p) {
      random.play();
    } else {
      greedy.play();
    }
  }
}