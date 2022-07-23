part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();

  const factory HomeEvent.updateNickName(String? nickName) = _UpdateNickName;

  const factory HomeEvent.joinRoom() = _JoinRoom;

  const factory HomeEvent.updateRoomKey(int? roomKey) = _UpdateRoomKey;

  const factory HomeEvent.updateRoomPlayers(List<Player>? players) = _UpdateRoomPlayers;

  const factory HomeEvent.updateConnectionResult(ConnectionResult? connectionResult) = _UpdateConnectionResult;

  const factory HomeEvent.createRoom() = _CreateRoom;

  const factory HomeEvent.updateError(String? error) = _UpdateError;
}

class _UpdateError extends HomeEvent {
  final String? error;

  const _UpdateError(this.error);
}

class _UpdateNickName extends HomeEvent {
  final String? nickName;

  const _UpdateNickName(this.nickName);
}

class _UpdateConnectionResult extends HomeEvent {
  final ConnectionResult? connectionResult;

  const _UpdateConnectionResult(this.connectionResult);
}

class _JoinRoom extends HomeEvent {
  const _JoinRoom();
}

class _UpdateRoomKey extends HomeEvent {
  final int? roomKey;

  const _UpdateRoomKey(this.roomKey);
}

class _UpdateRoomPlayers extends HomeEvent {
  final List<Player>? players;

  const _UpdateRoomPlayers(this.players);
}

class _CreateRoom extends HomeEvent {
  const _CreateRoom();
}