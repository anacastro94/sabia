import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../models/audio_player.dart';

class CloudRecordListView extends StatefulWidget {
  const CloudRecordListView({Key? key, required this.references})
      : super(key: key);
  final List<Reference> references;

  @override
  State<CloudRecordListView> createState() => _CloudRecordListViewState();
}

class _CloudRecordListViewState extends State<CloudRecordListView> {
  bool? isPlaying;
  late AudioPlayer player;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    player = AudioPlayer.create();
    selectedIndex = -1;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    player.play(await widget.references.elementAt(index).getDownloadURL());
    setState(() {
      selectedIndex = -1; // TODO: WILL GO WRONG
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.references.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(widget.references.elementAt(index).name),
          trailing: IconButton(
            icon: selectedIndex == index
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            onPressed: () => _onListTileButtonPressed(index),
          ),
        );
      },
    );
  }
}
