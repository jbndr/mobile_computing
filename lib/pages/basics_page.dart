import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/model/morse_character.dart';
import 'package:mobile_computing/ui/queue_box.dart';
import 'package:mobile_computing/ui/tiles.dart';
import 'package:provider/provider.dart';

class BasicPage extends StatefulWidget {
  @override
  BasicPageState createState() {
    return new BasicPageState();
  }
}

class BasicPageState extends State<BasicPage> {
  QueueBloc queueBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    queueBloc = Provider.of<QueueBloc>(context);
    print(queueBloc.queue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            StreamBuilder<Queue<MorseCharacter>>(
              stream: queueBloc.queueStream,
              initialData: queueBloc.queue,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.requireData.length == 0)
                  return SizedBox(
                    height: 50,
                  );
                Queue queue = snapshot.requireData;
                return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    height: 50.0,
                    child: Opacity(
                      opacity: queueBloc.isPaused ? 0.5 : 1.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: queue.length,
                          itemBuilder: (context, index) {
                            return QueueBox(
                                character: queue.elementAt(index).toString(),
                                isCurrent: index == 0);
                          }),
                    ));
              },
            ),
            Expanded(
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: _buildList(context))),
          ],
        ),
      ),
    );
  }

  ListView _buildList(context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            height: 25.0,
          ),
      itemCount: QueueBloc.morseCharacters.length,
      itemBuilder: (context, index) {
        return BasicTile(
            isConnected: (queueBloc.device != null),
            didFindService: (queueBloc.service != null),
            morseCharacter: QueueBloc.morseCharacters[index],
            onTap: () => queueBloc.playMorseCharacter(index));
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Basics"),
      actions: <Widget>[_buildBasicsPageActions()],
    );
  }

  Widget _buildBasicsPageActions() {
    return Builder(
      builder: (context) {
        return StreamBuilder<Queue>(
          stream: queueBloc.queueStream,
          initialData: queueBloc.queue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.requireData.isEmpty) {
              return SizedBox();
            } else {
              return Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: queueBloc.deleteQueue,
                  ),
                  StreamBuilder<bool>(
                    initialData: !queueBloc.isPaused,
                    stream: queueBloc.pausableStream,
                    builder: (context, snapshot) {
                      bool isPausable = snapshot.hasData ? snapshot.data : true;

                      if (isPausable) {
                        return IconButton(
                          onPressed: () {
                            queueBloc.setPausable(false);
                          },
                          icon: Icon(Icons.pause, color: Colors.white),
                        );
                      } else {
                        return IconButton(
                          onPressed: () {
                            queueBloc.setPausable(true);
                          },
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
