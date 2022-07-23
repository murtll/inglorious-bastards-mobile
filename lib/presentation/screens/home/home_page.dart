import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inglorious_bastards/application/home/home_bloc.dart';
import 'package:inglorious_bastards/presentation/screens/room/room_page.dart';
import 'package:inglorious_bastards/presentation/widgets/bloc_widgets/bloc_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: SizedBox(
                  width: 200,
                  child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.pinkAccent))),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Create new room"),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(Icons.add),
                          ],
                        )),
                    onPressed: () async {
                      await _showNickNameInputDialog(
                          connectionType: ConnectionType.createRoom,
                          context: context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: SizedBox(
                  width: 200,
                  child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.blueAccent))),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Join room"),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(Icons.person_add_alt_1_rounded),
                          ],
                        )),
                    onPressed: () async {
                      await _showNickNameInputDialog(
                          connectionType: ConnectionType.joinRoom,
                          context: context);
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

Future _showNickNameInputDialog(
    {required ConnectionType connectionType,
    required BuildContext context}) async {
  await showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          body: BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(),
            child: NickNameInputDialog(
              connectionType: connectionType,
              context: context,
            ),
          ),
        );
      });
}

class NickNameInputDialog extends StatelessWidget {
  final ConnectionType connectionType;
  final BuildContext context;
  const NickNameInputDialog(
      {required this.connectionType, required this.context});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();

    bloc.stream.listen((state) {
      print(state.connectionResult);
      switch (state.connectionResult) {
        case ConnectionResult.ok:
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RoomPage(rootBloc: bloc)));
          break;
        case ConnectionResult.error:
          _showFailedBar(state.error ?? 'Unexpected error');
          bloc.add(
              const HomeEvent.updateConnectionResult(ConnectionResult.clear));
          break;
        case ConnectionResult.emptyNickName:
          _showFailedBar('Please fill out nickname');
          bloc.add(
              const HomeEvent.updateConnectionResult(ConnectionResult.clear));
          break;
        case ConnectionResult.emptyRoomKey:
          _showFailedBar('Please fill out room key');
          bloc.add(
              const HomeEvent.updateConnectionResult(ConnectionResult.clear));
          break;
        default:
          break;
      }
    });

    late final String headerText;
    List<Widget> items = [];
    if (connectionType == ConnectionType.joinRoom) {
      headerText = 'Join room';
      items.add(Padding(
          padding: const EdgeInsets.only(right: 50, left: 50, top: 170),
          child: BlocTextField<HomeBloc, HomeState, int>(
            labelText: 'Room Key',
            keyboardType: TextInputType.number,
            onChanged: (roomKey) => bloc.add(HomeEvent.updateRoomKey(roomKey)),
            bloc: bloc,
            stateValue: (state) => state.roomKey,
            inputToValue: (value) {
              try {
                return int.parse(value);
              } catch (e) {
                return 0;
              }
            },
          )));

      items.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: BlocTextField<HomeBloc, HomeState, String>(
            labelText: 'Nickname',
            onChanged: (nickname) =>
                bloc.add(HomeEvent.updateNickName(nickname)),
            bloc: bloc,
            stateValue: (state) => state.nickname,
            inputToValue: (value) => value,
          )));

      items.add(TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.blueAccent)))),
          onPressed: () {
            bloc.add(const HomeEvent.joinRoom());
          },
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Join',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent)))));
    } else {
      headerText = 'Create room';
      items.add(Padding(
          padding:
              const EdgeInsets.only(right: 50, left: 50, top: 170, bottom: 10),
          child: BlocTextField<HomeBloc, HomeState, String>(
            labelText: 'Nickname',
            onChanged: (nickname) {
              print(nickname);
              bloc.add(HomeEvent.updateNickName(nickname));
            },
            bloc: bloc,
            stateValue: (state) => state.nickname,
            inputToValue: (value) => value,
          )));

      items.add(TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.pinkAccent)))),
          onPressed: () {
            bloc.add(const HomeEvent.createRoom());
          },
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Create',
                  style: TextStyle(fontSize: 16, color: Colors.pinkAccent)))));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(headerText),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        )
      ],
    );
  }

  _showFailedBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        content: Row(
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(
              width: 20,
            ),
            Text(message),
            // CircularProgressIndicator()
          ],
        ),
      ));
}

enum ConnectionType {
  createRoom,
  joinRoom,
}
