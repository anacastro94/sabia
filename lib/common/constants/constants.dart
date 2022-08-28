import 'dart:ui';
import 'package:flutter/material.dart';

const String kLogoTag = 'logo';

const Color kGreenLight = Color(0xFFF3F5EC);
const Color kGreenOlivine = Color(0xFFA7BC79);
const Color kAntiqueWhite = Color(0xFFFFFCF7);
const Color kDarkOrange = Color(0xFFFE8900);
const Color kBlackOlive = Color(0xFF4C483D);
const Color kGrey = Color(0xFF89745F);

const kButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const kTextStyleMenuItem = TextStyle(
  fontSize: 16,
  color: kBlackOlive,
);

const kTextStyleAppBarTitle = TextStyle(
  color: Colors.white,
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

const kLogoUrl =
    'https://firebasestorage.googleapis.com/v0/b/bbk-final-project.appspot.com/o/images%2FLogo.png?alt=media&token=7055cff2-c88e-4a32-b672-7e625486d61f';

const kGiphyApiKey = 'WSrfRTGSBls6xm1FFiVLVj2g6XcBkZSw';

const String _urlPrefix =
    'https://firebasestorage.googleapis.com/v0/b/bbk-final-project.appspot.com/o/images';

const List<String> kArtworkUrls = [
  '$_urlPrefix%2Fc3.png?alt=media&token=56c0c368-36d8-4054-9455-dc9ba82dc8f1'
      '$_urlPrefix%2Fc2.png?alt=media&token=300a5735-29cf-44e3-a84d-ee1e77446575',
  '$_urlPrefix%2Fc1.png?alt=media&token=ec4c0419-59fb-40f2-b934-46c51fd37a90',
  '$_urlPrefix%2Fc4.png?alt=media&token=72b2a76e-22c0-4f9a-af38-26b9e6d878d1',
  '$_urlPrefix%2Fc5.png?alt=media&token=fed568c3-9e55-424d-8a83-c813291453cb',
  '$_urlPrefix%2Fc6.png?alt=media&token=aa071c1a-39eb-444c-94b4-119d4593b796',
  '$_urlPrefix%2Fc7.png?alt=media&token=ba6dc5ab-77cf-47c3-9cbb-2d3800f376d2',
  '$_urlPrefix%2Fc8.png?alt=media&token=27e345c8-39dd-4f63-8431-6555600f80f0',
  '$_urlPrefix%2Fc9.png?alt=media&token=ceaff1ac-5a1b-4788-a08c-4ea17bea2f8f',
  '$_urlPrefix%2Fc10.png?alt=media&token=a8f415f4-8c78-4a22-9b11-e924ba8691ac',
  '$_urlPrefix%2Fc11.png?alt=media&token=3e69ee71-b2b6-42da-98ab-88780e99159c',
];
