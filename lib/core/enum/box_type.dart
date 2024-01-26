enum BoxType {
  team('team'),
  player('player'),
  inning('inning'),
  match('match');

  final String name;
  const BoxType(this.name);
}
