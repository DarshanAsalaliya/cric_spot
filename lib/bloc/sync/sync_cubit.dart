import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cric_spot/bloc/sync/sync_state.dart';
import 'package:cric_spot/service/supabase_sync_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SyncCubit extends Cubit<SyncState> {
  final SupabaseSyncService _syncService;
  final Box<Map> _syncQueueBox;
  StreamSubscription? _connectivitySubscription;

  SyncCubit({
    required SupabaseSyncService syncService,
    required Box<Map> syncQueueBox,
  })  : _syncService = syncService,
        _syncQueueBox = syncQueueBox,
        super(const SyncState()) {
    _init();
  }

  void _init() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      final connected = result != ConnectivityResult.none;
      emit(state.copyWith(isConnected: connected));
      if (connected) {
        drainQueue();
      } else {
        emit(state.copyWith(status: SyncStatus.offline));
      }
    });
    // Check initial connectivity
    Connectivity().checkConnectivity().then((result) {
      final connected = result != ConnectivityResult.none;
      emit(state.copyWith(
        isConnected: connected,
        status: connected ? SyncStatus.idle : SyncStatus.offline,
      ));
    });
  }

  /// Enqueue a sync operation when offline.
  void enqueue(Map<String, dynamic> operation) {
    _syncQueueBox.add(operation);
    emit(state.copyWith(queueSize: _syncQueueBox.length));
  }

  /// Drain the sync queue when connectivity is restored.
  Future<void> drainQueue() async {
    if (_syncQueueBox.isEmpty || !_syncService.isAuthenticated) {
      emit(state.copyWith(
        status: SyncStatus.idle,
        queueSize: _syncQueueBox.length,
      ));
      return;
    }

    emit(state.copyWith(status: SyncStatus.syncing));

    final keys = _syncQueueBox.keys.toList();
    for (final key in keys) {
      try {
        final operation = Map<String, dynamic>.from(_syncQueueBox.get(key)!);
        await _syncService.processSyncOperation(operation);
        await _syncQueueBox.delete(key);
      } catch (e) {
        log('SyncCubit.drainQueue error: $e');
        emit(state.copyWith(
          status: SyncStatus.error,
          queueSize: _syncQueueBox.length,
          lastError: e.toString(),
        ));
        return;
      }
    }

    emit(state.copyWith(
      status: SyncStatus.idle,
      queueSize: 0,
    ));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
