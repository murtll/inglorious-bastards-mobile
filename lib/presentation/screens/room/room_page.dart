import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:inglorious_bastards/application/home/home_bloc.dart';
import 'package:inglorious_bastards/application/room/room_bloc.dart';
import 'package:inglorious_bastards/models/player.dart';

class RoomPage extends StatelessWidget {
  final HomeBloc rootBloc;

  const RoomPage({Key? key, required this.rootBloc})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final bloc = RoomBloc(rootBloc.state.players, rootBloc.state.roomKey);

    bloc.roomService = rootBloc.roomService;
    bloc.roomService.setListener((json) {
      if (json['type'] == 'roomData') {
        bloc.add(RoomEvent.updateRoomPlayers(json['data']['players']
            .map((e) => Player.fromJson(e))
            .toList()
            .cast<Player>()));
      } else if (json['type'] == 'error') {
        print(json['data']['error']);
      }
    });

    return Scaffold(
        body: SafeArea(
      child: BlocBuilder<RoomBloc, RoomState>(
          bloc: bloc,
          builder: (context, state) => Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text('Players'),
                    const SizedBox(
                      height: 20,
                    ),
                    bloc.state.players.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: bloc.state.players
                                .map((player) => Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: HexColor.fromHex(player.color), //color of border
                                      width: 2, //width of border
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(player.username),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Image.network(
                                          'http://${dotenv.env['API_HOST']}:${dotenv.env['API_PORT']}/picture/${player.pictureKey}',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(player.pictureName)
                                      ],
                                    )))
                                .toList(),
                          )
                        : const Text("No players yet"),
                    const SizedBox(
                      height: 150,
                    ),
                    const Text(
                      "Room key",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      bloc.state.roomKey.toString(),
                      style: const TextStyle(fontSize: 40, letterSpacing: 20),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.redAccent))),
                            foregroundColor:
                            MaterialStateProperty.all(Colors.redAccent)),
                        onPressed: () {
                          bloc.roomService.closeSocket();
                          Navigator.of(context).pop();
                        }, child: const Padding(padding: EdgeInsets.all(10), child: Text('Leave the game')))
                  ],
                ),
              )),
    ));
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}