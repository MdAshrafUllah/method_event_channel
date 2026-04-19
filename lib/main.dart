import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel("say_name");
  static const evenChannel = EventChannel("timer_channel");

  String _name = 'No one say name';

  int _counter = 0;
  String _status = 'Stopped';
  bool _isRunning = false;
  Stream? _stream;

  @override
  void initState() {
    super.initState();
    _listenToTimer();
  }

  Future<void> _getNameFromNative() async {
    try {
      final String result = await platform.invokeMethod('getName');
      _name = result;
    } catch (e) {
      _name = 'Error: $e';
    }
    setState(() {});
  }

  void _listenToTimer() {
    _stream = evenChannel.receiveBroadcastStream();
    _stream?.listen(
      (event) {
        setState(() {
          _counter = event['count'] ?? 0;
          _status = event['status'] ?? "Unknown";
          _isRunning = event['isRunning'] ?? false;
        });
      },
      onError: (error) {
        setState(() {
          _status = "Error: $error";
        });
      },
    );
  }

  void _startTimer() {
    const MethodChannel('timer_control').invokeMethod('start_timer');
  }

  void _stopTimer() {
    const MethodChannel('timer_control').invokeMethod('stop_timer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Method & Event Channel Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: $_name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getNameFromNative,
              child: Text('Get name from Native'),
            ),

            Text(
              'Counter: $_counter',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Status: $_status',
              style: TextStyle(
                fontSize: 20,
                color: _isRunning ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Start Timer'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Stop Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
