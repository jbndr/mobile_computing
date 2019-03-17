import 'package:flutter/material.dart';
import 'package:mobile_computing/logic/queue_logic.dart';
import 'package:mobile_computing/pages/game.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() {
    return new HomePageState();
  }

}

class HomePageState extends State<HomePage> {

  QueueBloc queueBloc;

  bool isPlaying = false;
  bool get isConnected => (queueBloc.device != null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    queueBloc = Provider.of<QueueBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        isConnected ? _buildHomePage() : _buildDeviceNotConnected()
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Home"),
    );
  }

  Widget _buildDeviceNotConnected() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBluetoothIcon(),
            SizedBox(height: 20),
            Text("No device connected!",
                style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text("Please connect to your device.",
                style: TextStyle(fontSize: 16.0, color: Colors.grey))
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    if (isPlaying){
      return Expanded(
        child: Game(queueBloc),
      );
    } else {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPlayButton(),
          ],
        ),
      );
    }
  }

  Widget _buildPlayButton() {
    return Container(
      child: GestureDetector(
        onTap: (){
          setState(() {
            isPlaying = true;
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Icon(
              Icons.play_arrow,
              size: 150,
              color: Colors.white,
            )),
      ),
    );
  }


  Widget _buildBluetoothIcon() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Icon(
          Icons.bluetooth,
          size: 150,
          color: Colors.white,
        ));
  }
  
}
