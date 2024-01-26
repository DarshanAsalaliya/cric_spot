enum WicketType {
  bowled('Bowled'),
  catchOut('Catch Out'),
  runoutStriker('Runout Striker'),
  runoutNonStriker('Runout Non-Striker'),
  stumpping('Stumpping'),
  lbw('Lbw'),
  hitWicket('Hit-Wicket');

  final String name;
  const WicketType(this.name);
}
