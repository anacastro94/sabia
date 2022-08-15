import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<GiphyGif?> pickGif(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(context: context, apiKey: kGiphyApiKey);
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}
