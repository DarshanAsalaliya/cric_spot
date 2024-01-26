enum PageType {
  newMatch,
  teams,
  history;

  int get toIndex {
    switch (this) {
      case PageType.newMatch:
        return 0;
      case PageType.teams:
        return 1;
      case PageType.history:
        return 2;
    }
  }

  String get name {
    switch (this) {
      case PageType.newMatch:
        return "New Match";
      case PageType.teams:
        return "Teams";
      case PageType.history:
        return "History";
    }
  }
}
