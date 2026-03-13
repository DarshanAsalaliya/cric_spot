enum SyncStatus { idle, syncing, offline, error }

class SyncState {
  final SyncStatus status;
  final int queueSize;
  final bool isConnected;
  final String? lastError;

  const SyncState({
    this.status = SyncStatus.idle,
    this.queueSize = 0,
    this.isConnected = true,
    this.lastError,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? queueSize,
    bool? isConnected,
    String? lastError,
  }) {
    return SyncState(
      status: status ?? this.status,
      queueSize: queueSize ?? this.queueSize,
      isConnected: isConnected ?? this.isConnected,
      lastError: lastError ?? this.lastError,
    );
  }
}
