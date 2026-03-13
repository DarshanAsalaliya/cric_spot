enum RoutesName {
  login,
  landing,
  newMatch,
  teams,
  history,
  scoreCount,
  scoreBoard,
  adwanceSetting,
  setting,
  selectBowler,
  playerSelect,
  fallOfWicket,
  winningPage,
  signup,
  joinLive,
  liveScore,
  playerProfile,
  tournamentList,
  createTournament,
  tournamentDetail,
  otpVerification,
  userProfile,
  ;
}

extension RoutesNameHelper on RoutesName {
  String get name {
    switch (this) {
      case RoutesName.login:
        return 'login';
      case RoutesName.landing:
        return 'landing';
      case RoutesName.newMatch:
        return 'new-match';
      case RoutesName.teams:
        return 'teams';
      case RoutesName.history:
        return 'history';
      case RoutesName.adwanceSetting:
        return 'adwance-setting';
      case RoutesName.setting:
        return 'setting';
      case RoutesName.scoreCount:
        return 'score-count';
      case RoutesName.scoreBoard:
        return 'score-board';
      case RoutesName.playerSelect:
        return 'player-select';
      case RoutesName.selectBowler:
        return 'select-bowler';
      case RoutesName.fallOfWicket:
        return 'fall-of-wicket';
         case RoutesName.winningPage:
        return 'winning-page';
      case RoutesName.signup:
        return 'signup';
      case RoutesName.joinLive:
        return 'join-live';
      case RoutesName.liveScore:
        return 'live-score';
      case RoutesName.playerProfile:
        return 'player-profile';
      case RoutesName.tournamentList:
        return 'tournament-list';
      case RoutesName.createTournament:
        return 'create-tournament';
      case RoutesName.tournamentDetail:
        return 'tournament-detail';
      case RoutesName.otpVerification:
        return 'otp-verification';
      case RoutesName.userProfile:
        return 'user-profile';
    }
  }

  String get path {
    switch (this) {
      case RoutesName.login:
        return '/login';
      case RoutesName.landing:
        return '/landing';
      case RoutesName.newMatch:
        return '/new-match';
      case RoutesName.teams:
        return '/teams';
      case RoutesName.history:
        return '/history';
      case RoutesName.adwanceSetting:
        return '/adwance-setting';
      case RoutesName.setting:
        return '/setting';
      case RoutesName.scoreCount:
        return '/score-count/:matchId';
      case RoutesName.scoreBoard:
        return '/score-board/:matchId';
      case RoutesName.playerSelect:
        return '/player-select';
      case RoutesName.selectBowler:
        return '/select-bowler';
      case RoutesName.fallOfWicket:
        return '/fall-of-wicket/:run';
         case RoutesName.winningPage:
        return '/winning-page';
      case RoutesName.signup:
        return '/signup';
      case RoutesName.joinLive:
        return '/join-live';
      case RoutesName.liveScore:
        return '/live-score/:matchId';
      case RoutesName.playerProfile:
        return '/player-profile/:playerId';
      case RoutesName.tournamentList:
        return '/tournaments';
      case RoutesName.createTournament:
        return '/create-tournament';
      case RoutesName.tournamentDetail:
        return '/tournament/:tournamentId';
      case RoutesName.otpVerification:
        return '/otp-verification/:email';
      case RoutesName.userProfile:
        return '/user-profile';
    }
  }
}
