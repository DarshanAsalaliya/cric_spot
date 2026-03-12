part of '../match_setup_bloc.dart';

/// Validation-related event handlers for [MatchSetupBloc].
mixin MatchSetupValidationMixin on Bloc<MatchSetupEvent, MatchSetupState> {
  void _onValidate(
    MatchSetupValidate event,
    Emitter<MatchSetupState> emit,
  ) {
    String? hostError;
    String? visitorError;
    String? overErr;

    if (state.hostTeamName.isEmpty) {
      hostError = 'This field is require';
    }
    if (state.visitorTeamName.isEmpty) {
      visitorError = 'This field is required';
    }
    if (state.over.isEmpty) {
      overErr = 'This field is required';
    }
    if (state.hostTeamName == state.visitorTeamName &&
        state.hostTeamName.isNotEmpty) {
      visitorError = 'Both team should be diffrent';
    }

    emit(state.copyWith(
      hostTeamNameError: () => hostError,
      visitorTeamNameError: () => visitorError,
      overError: () => overErr,
    ));
  }

  void _onValidateOpener(
    MatchSetupValidateOpener event,
    Emitter<MatchSetupState> emit,
  ) {
    String? strikerErr;
    String? nonStrikerErr;
    String? bowlerErr;

    if (state.strikerName.isEmpty) {
      strikerErr = 'This field is require';
    }
    if (state.nonStrikerName.isEmpty) {
      nonStrikerErr = 'This field is required';
    }
    if (state.openingBowlerName.isEmpty) {
      bowlerErr = 'This field is required';
    }

    emit(state.copyWith(
      strikerNameError: () => strikerErr,
      nonStrikerNameError: () => nonStrikerErr,
      openingBowlerNameError: () => bowlerErr,
    ));
  }
}
