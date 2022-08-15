import 'dart:ui';
import 'package:flutter/material.dart';

const String kLogoTag = 'logo';

const Color kGreenOlivine = Color(0xFFA7BC79);
const Color kAntiqueWhite = Color(0xFFFFF0DD);
const Color kDarkOrange = Color(0xFFFE8900);
const Color kBlackOlive = Color(0xFF4C483D);
const Color kGrey = Color(0xFF89745F);

const kButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Hint text...',
  filled: true,
  fillColor: kAntiqueWhite,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kBlackOlive, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
);

const kStandardProfilePicUrl =
    'https://firebasestorage.googleapis.com/v0/b/bbk-final-project.appspot.com/o/images%2FStandardAvatar.png?alt=media&token=5f0f0d94-2b8a-4b2f-8e65-5d65d3d31da1';

const kGiphyApiKey = 'WSrfRTGSBls6xm1FFiVLVj2g6XcBkZSw';
