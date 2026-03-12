part of '../match_setup_bloc.dart';

/// Settings-related event handlers for [MatchSetupBloc].
mixin MatchSetupSettingsMixin on Bloc<MatchSetupEvent, MatchSetupState> {
  void _onNoBallToggled(
    MatchSetupNoBallToggled event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(isNoBall: event.isNoBall));
  }

  void _onWideBallToggled(
    MatchSetupWideBallToggled event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(isWideBall: event.isWideBall));
  }

  void _onNoBallReBallToggled(
    MatchSetupNoBallReBallToggled event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(noBallReBall: event.noBallReBall));
  }

  void _onWideBallReBallToggled(
    MatchSetupWideBallReBallToggled event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(wideReBall: event.wideReBall));
  }

  void _onNoBallRunChanged(
    MatchSetupNoBallRunChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(noBallRun: event.noBallRun));
  }

  void _onWideBallRunChanged(
    MatchSetupWideBallRunChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(wideBallRun: event.wideBallRun));
  }

  void _onPlayerPerMatchChanged(
    MatchSetupPlayerPerMatchChanged event,
    Emitter<MatchSetupState> emit,
  ) {
    emit(state.copyWith(playerPerMatch: event.playerPerMatch));
  }
}
