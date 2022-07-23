part of 'room_bloc.dart';

class RoomState with EquatableMixin {
  final bool isRefreshing;
  final String? nickname;
  final int? roomKey;
  final ConnectionResult? connectionResult;
  final List<Player> players;

  const RoomState({required this.isRefreshing, required this.players, this.nickname, this.connectionResult, this.roomKey});

  factory RoomState.initial(List<Player> players, int? roomKey) => RoomState(isRefreshing: false, players: players, roomKey: roomKey);

  RoomState copyWith({
    bool? isRefreshing,
    Option<String?>? nickname,
    Option<int?>? roomKey,
    ConnectionResult? connectionResult,
    List<Player>? players,
  }) => RoomState(
    isRefreshing: isRefreshing ?? this.isRefreshing,
    nickname: nickname == null ? this.nickname : nickname.toNullable(),
    roomKey: roomKey == null ? this.roomKey : roomKey.toNullable(),
    connectionResult: connectionResult ?? this.connectionResult,
    players: players ?? this.players,
  );

  @override
  List<Object?> get props => [
    isRefreshing,
    nickname,
    roomKey,
    connectionResult,
    players,
  ];

}

enum ConnectionResult {
  ok,
  badNickName,
  badRoomKey,
  emptyNickName,
  emptyRoomKey
}