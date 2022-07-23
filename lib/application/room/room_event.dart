part of 'room_bloc.dart';

abstract class RoomEvent {
  const RoomEvent();

  const factory RoomEvent.updateRoomKey(int? roomKey) = _UpdateRoomKey;

  const factory RoomEvent.updateRoomPlayers(List<Player>? players) = _UpdateRoomPlayers;

  const factory RoomEvent.leaveRoom() = _LeaveRoom;
}

class _UpdateRoomKey extends RoomEvent {
  final int? roomKey;

  const _UpdateRoomKey(this.roomKey);
}

class _UpdateRoomPlayers extends RoomEvent {
  final List<Player>? players;

  const _UpdateRoomPlayers(this.players);
}

class _LeaveRoom extends RoomEvent {
  const _LeaveRoom();
}