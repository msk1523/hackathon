import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlertPage extends StatefulWidget {
  final bool adminTriggered;
  final String? previousScreen;

  AlertPage({Key? key, required this.adminTriggered, this.previousScreen})
      : super(key: key);

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  late AudioPlayer _audioPlayer;
  late Timer _timer;
  int _remainingTime = 30;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startAlarm();
    _startTimer();
  }

  Future<void> _startAlarm() async {
    await _audioPlayer.setSourceAsset('audio/alarm.mp3');
    _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _showNotification();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Channel',
      priority: Priority.max,
      importance: Importance.max,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'ReliefLink Alarm', 'Alarm has been triggered', notificationDetails);
  }

  Future<void> _stopAlarm() async {
    await _audioPlayer.stop();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _stopAlarm();
        Navigator.pop(context);
        if (widget.adminTriggered) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Help is arriving on the way!",
          )));
        }

        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _stopAlarm();
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _iAmSafe() {
    _stopAlarm();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ALARM TRIGGERED',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '$_remainingTime',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iAmSafe,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text(
                'I\'m Safe',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
