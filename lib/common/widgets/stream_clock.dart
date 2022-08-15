import 'package:flutter/material.dart';
import '../../models/time.dart';

class StreamClock extends StatefulWidget {
  const StreamClock({Key? key, this.stream, required this.isRecording})
      : super(key: key);
  final Stream? stream;
  final bool isRecording;

  @override
  State<StreamClock> createState() => _StreamClockState();
}

class _StreamClockState extends State<StreamClock> {
  late String _clockText;

  @override
  void initState() {
    _clockText = '00:00:00';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.stream!.listen((event) {
      var time = widget.isRecording
          ? Time.fromSeconds(event.duration.inSeconds)
          : Time.fromSeconds(event.position.inSeconds);
      setState(() {
        _clockText = time.toString();
      });
    });
    return Text(_clockText);
  }
}
