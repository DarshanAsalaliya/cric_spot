import 'dart:async';
import 'dart:developer';

import 'package:cric_spot/bloc/auth/auth_state.dart';
import 'package:cric_spot/bloc/player_profile/player_profile_state.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient _client = Supabase.instance.client;
  StreamSubscription? _authSubscription;

  AuthCubit() : super(const AuthState()) {
    _listenToAuthChanges();
    checkAuthStatus();
  }

  void _listenToAuthChanges() {
    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
          displayName: session.user.userMetadata?['display_name'] as String?,
        ));
        loadFullProfile();
      } else if (state.status != AuthStatus.otpSent) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          displayName: null,
          username: null,
          careerStats: null,
          myTournaments: const [],
        ));
      }
    });
  }

  void checkAuthStatus() {
    final session = _client.auth.currentSession;
    if (session != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: session.user,
        displayName: session.user.userMetadata?['display_name'] as String?,
      ));
      loadFullProfile();
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Load profile data, career stats, and tournaments from Supabase.
  Future<void> loadFullProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    // Load profile (username, display_name)
    try {
      final profile = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (profile != null) {
        emit(state.copyWith(
          displayName: profile['display_name'] as String?,
          username: profile['username'] as String?,
        ));
      }
    } catch (e) {
      log('AuthCubit.loadFullProfile profile error: $e');
    }

    // Load career stats (from user_career_stats view)
    try {
      final stats = await _client
          .from('user_career_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (stats != null) {
        emit(state.copyWith(careerStats: stats));
      }
    } catch (e) {
      log('AuthCubit.loadFullProfile career stats error: $e');
    }

    // Load tournaments and format stats via player record
    try {
      final player = await _client
          .from('players')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (player != null) {
        final playerId = player['id'] as String;

        // Load tournaments
        try {
          final tournaments = await _client
              .from('player_tournaments')
              .select()
              .eq('player_id', playerId);
          emit(state.copyWith(
            myTournaments: List<Map<String, dynamic>>.from(tournaments),
          ));
        } catch (e) {
          log('AuthCubit.loadFullProfile tournaments error: $e');
        }

        // Load format stats
        try {
          final formatResults = await _client.rpc(
            'get_player_format_stats',
            params: {'p_player_id': playerId},
          );
          final formatList = (formatResults as List)
              .map((e) => FormatStats.fromMap(Map<String, dynamic>.from(e)))
              .toList();
          emit(state.copyWith(formatStats: formatList));
        } catch (e) {
          log('AuthCubit.loadFullProfile format stats error: $e');
        }
      }
    } catch (e) {
      log('AuthCubit.loadFullProfile player lookup error: $e');
    }
  }

  /// Sign up with email — Supabase sends OTP email for verification.
  Future<void> signUpWithEmail(String email, String password, String displayName) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      if (response.user != null && response.session == null) {
        emit(state.copyWith(
          status: AuthStatus.otpSent,
          pendingEmail: email,
          displayName: displayName,
        ));
      } else if (response.user != null && response.session != null) {
        await _onAuthSuccess(response.user!, displayName);
      }
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      log('AuthCubit.signUpWithEmail error: $e');
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Sign up failed. Please try again.',
      ));
    }
  }

  /// Verify OTP code sent to email after signup.
  Future<void> verifyOtp(String otp) async {
    final email = state.pendingEmail;
    if (email == null) return;

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _client.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: otp,
      );

      if (response.user != null) {
        await _onAuthSuccess(response.user!, state.displayName);
      }
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: e.message,
      ));
    } catch (e) {
      log('AuthCubit.verifyOtp error: $e');
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: 'Verification failed. Please try again.',
      ));
    }
  }

  /// Resend OTP to the pending email.
  Future<void> resendOtp() async {
    final email = state.pendingEmail;
    if (email == null) return;
    try {
      await _client.auth.resend(type: OtpType.signup, email: email);
    } catch (e) {
      log('AuthCubit.resendOtp error: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await _onAuthSuccess(
          response.user!,
          response.user?.userMetadata?['display_name'] as String?,
        );
      }
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
    } catch (e) {
      log('AuthCubit.signInWithEmail error: $e');
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Sign in failed.'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _client.auth.signInWithOAuth(OAuthProvider.google);
    } on AuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
    } catch (e) {
      log('AuthCubit.signInWithGoogle error: $e');
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Google sign in failed.'));
    }
  }

  /// Update display name.
  Future<void> updateDisplayName(String newName) async {
    try {
      await _client.auth.updateUser(UserAttributes(data: {'display_name': newName}));
      await _client.from('profiles').update({'display_name': newName}).eq('id', _client.auth.currentUser!.id);
      emit(state.copyWith(displayName: newName));
    } catch (e) {
      log('AuthCubit.updateDisplayName error: $e');
    }
  }

  /// Update username (unique).
  Future<bool> updateUsername(String newUsername) async {
    try {
      await _client.from('profiles').update({
        'username': newUsername.toLowerCase().trim(),
      }).eq('id', _client.auth.currentUser!.id);
      emit(state.copyWith(username: newUsername.toLowerCase().trim()));
      return true;
    } catch (e) {
      log('AuthCubit.updateUsername error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onAuthSuccess(User user, String? displayName) async {
    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'display_name': displayName ?? user.email,
      });
    } catch (e) {
      log('AuthCubit._onAuthSuccess profile upsert error: $e');
    }

    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      displayName: displayName,
    ));

    // Sync all local Hive data to Supabase in background
    try {
      final syncService = GetIt.instance.get<SupabaseSyncService>();
      syncService.syncAllLocalData();
    } catch (e) {
      log('AuthCubit._onAuthSuccess sync error: $e');
    }

    loadFullProfile();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
