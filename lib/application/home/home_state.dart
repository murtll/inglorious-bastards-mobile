part of 'home_bloc.dart';

class HomeState with EquatableMixin {
  final String? nickname;
  final int? roomKey;
  final ConnectionResult? connectionResult;
  final String? error;
  final List<Player> players;

  const HomeState({required this.players, this.nickname, this.connectionResult, this.roomKey, this.error});

  factory HomeState.initial() => const HomeState(players: []);

  HomeState copyWith({
    Option<String?>? nickname,
    Option<int?>? roomKey,
    ConnectionResult? connectionResult,
    List<Player>? players,
    Option<String?>? error
  }) => HomeState(
    nickname: nickname == null ? this.nickname : nickname.toNullable(),
    roomKey: roomKey == null ? this.roomKey : roomKey.toNullable(),
    connectionResult: connectionResult ?? this.connectionResult,
    players: players ?? this.players,
    error: error == null ? this.error : error.toNullable()
  );

  @override
  List<Object?> get props => [
    nickname,
    roomKey,
    connectionResult,
    players,
    error
  ];

}

enum ConnectionResult {
  ok,
  emptyNickName,
  emptyRoomKey,
  error,
  clear
}