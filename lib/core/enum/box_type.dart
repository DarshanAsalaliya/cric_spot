enum BoxType {
  team('team'),
  player('player'),
  inning('inning'),
  match('match'),
  syncQueue('syncQueue');

  final String name;
  const BoxType(this.name);
}
