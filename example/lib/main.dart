
import 'package:flutter/material.dart';
import 'package:sys_volume/flutter_volume.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool sliding = false;
  double sliderVal = 0;
  double volume = 0;
  double step = 1.0 / 16.0;

  @override
  void initState() {
    super.initState();
    FlutterVolume.get().then((v) {
      setState(() {
        volume = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: VolumeWatcher(
          watcher: (vol) {
            setState(() {
              volume = vol.vol;
            });
          },
          child: Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      FlutterVolume.up();
                      setState(() {  
                        volume += step;

                          if(volume > 1.0) {
                            volume = 1.0;
                          }
                      });
                    },
                    child: Text("up")),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.down();
                      setState(() {      
                        volume -= step;
                        
                        if(volume < 0.0) {
                          volume = 0.0;
                        }
                      });
                    },
                    child: Text("down")),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.mute();
                    },
                    child: Text("mute")),
                Slider(
                  value: sliding ? sliderVal : volume,
                  onChangeStart: (v) {
                    setState(() {
                      sliding = true;
                    });
                  },
                  onChangeEnd: (v) {
                    FlutterVolume.set(v).then((_) {
                      setState(() {
                        sliding = false;
                      });
                    });
                  },
                  onChanged: (v) {
                    FlutterVolume.set(v);
                    setState(() {
                      sliderVal = v;
                    });
                  },
                ),

                Expanded(child: Container(),),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.enableWatcher();
                      FlutterVolume.get().then((v) {
                        setState(() {
                          volume = v;
                        });
                      });
                    },
                    child: Text("enable watch")),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.disableWatcher();
                    },
                    child: Text("disable watch")),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.enableUI();
                    },
                    child: Text("enable OS UI")),
                FlatButton(
                    onPressed: () {
                      FlutterVolume.disableUI();
                    },
                    child: Text("disable OS UI")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
