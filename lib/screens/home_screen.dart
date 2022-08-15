import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../auth/screens/edit_user_info_screen.dart';
import '../common/widgets/cloud_record_list_view.dart';
import '../common/widgets/feature_buttons_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reference> references = [];

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult =
        await firebaseStorage.ref().child('bbk-final-project').list();
    setState(() {
      references = listResult.items;
    });
  }

  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Example'),
          actions: [
            CircleAvatar(
              child: IconButton(
                  onPressed: () => Navigator.pushNamed(
                      context, EditUserInformationScreen.id),
                  icon: const Icon(Icons.account_circle_rounded)),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: references.isEmpty
                  ? const Center(
                      child: Text('No File uploaded yet'),
                    )
                  : CloudRecordListView(
                      references: references,
                    ),
            ),
            Expanded(
              flex: 2,
              child: FeatureButtonsView(
                onUploadComplete: _onUploadComplete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
