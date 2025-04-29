import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class Coordinates {
  double latitude;
  double longitude;
  Coordinates(this.latitude, this.longitude);

  @override
  String toString() => '($latitude, $longitude)';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Ambience Logger'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool permissionGranted = false;
  final record = AudioRecorder();
  final audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String? currentlyPlayingFile;
  late Directory customDirectory;
  List<FileSystemEntity> recordings = [];
  Map<String, double> intensityMap = {};
  Map<String, Coordinates> locationMap = {};
  Coordinates? currentLocation;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  List<List<double>> _accelData = [];

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  @override
  void dispose() {
    record.dispose();
    audioPlayer.dispose();
    _accelSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeStorage() async {
    await _checkPermissions();
    if (!permissionGranted) return;

    final path = '/storage/emulated/0/flutter_directory';
    customDirectory = Directory(path);

    if (!(await customDirectory.exists())) {
      await customDirectory.create(recursive: true);
    }

    _refreshRecordingList();
  }

  Future<void> _checkPermissions() async {
    final micPermission = await Permission.microphone.request();
    final storagePermission = await Permission.manageExternalStorage.request();
    final locationPermission = await Geolocator.requestPermission();

    permissionGranted =
        micPermission.isGranted && storagePermission.isGranted && locationPermission != LocationPermission.denied;
  }

  Future<void> getLocation() async {
    if (permissionGranted) {
      Position pos = await Geolocator.getCurrentPosition();
      var loc = Coordinates(pos.latitude, pos.longitude);
      setState(() {
        currentLocation = loc;
      });
    }
  }

  Future<void> _refreshRecordingList() async {
    if (await customDirectory.exists()) {
      final files = customDirectory
          .listSync()
          .where((file) => file.path.endsWith(".m4a"))
          .toList();

      files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      setState(() => recordings = files);
    }
  }

  Future<void> _startRecording() async {
    if (!permissionGranted) return;

    await getLocation();

    final count = recordings.length + 1;
    final filePath = '${customDirectory.path}/recording_$count.m4a';

    await record.start(
      RecordConfig(encoder: AudioEncoder.aacLc),
      path: filePath,
    );

    setState(() => isRecording = true);
    _startAccelerometer();
  }

  Future<void> _stopRecording() async {
    await record.stop();
    _stopAccelerometer();

    final magnitude = _computeVectorMagnitude();
    final fileName = 'recording_${recordings.length + 1}.m4a';

    setState(() {
      isRecording = false;
      intensityMap[fileName] = magnitude;
      if (currentLocation != null) {
        locationMap[fileName] = currentLocation!;
      }
    });

    await _refreshRecordingList();
  }

 void _startAccelerometer() {
  _accelData.clear();
  _accelSubscription = accelerometerEvents.listen((event) {
    // Add a delay of 250 ms before processing the next reading
    Future.delayed(Duration(milliseconds: 250), () {
      _accelData.add([event.x, event.y, event.z]);
    });
  });
}

  void _stopAccelerometer() {
    _accelSubscription?.cancel();
  }

  double _computeVectorMagnitude() {
    if (_accelData.isEmpty) return 0.0;

    double sum = 0;
    for (var triple in _accelData) {
      double magnitude = sqrt(
        pow(triple[0], 2) + pow(triple[1], 2) + pow(triple[2], 2),
      );
      sum += magnitude;
    }

    return double.parse((sum / _accelData.length).toStringAsFixed(2));
  }

  Future<void> _togglePlayback(String filePath) async {
    if (isPlaying && currentlyPlayingFile == filePath) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
        currentlyPlayingFile = null;
      });
    } else {
      await audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        isPlaying = true;
        currentlyPlayingFile = filePath;
      });

      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlaying = false;
          currentlyPlayingFile = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: OutlinedButton(
              onPressed: isRecording ? _stopRecording : _startRecording,
              child: Text(isRecording ? 'Stop ⏹' : 'Record ▶'),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final file = recordings[index];
                final fileName = file.path.split('/').last;
                final intensity = intensityMap[fileName];
                final loc = locationMap[fileName];
                final isHighIntensity = (intensity != null && intensity > 15);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: isHighIntensity ? Colors.red[100] : Colors.white,
                  child: ListTile(
                    title: Text(fileName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (loc != null) Text('Location: ${loc.toString()}'),
                        if (intensity != null) Text('Motion Intensity: $intensity'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        (isPlaying && currentlyPlayingFile == file.path)
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      onPressed: () => _togglePlayback(file.path),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
