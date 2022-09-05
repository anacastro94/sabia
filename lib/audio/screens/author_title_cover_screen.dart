import 'package:bbk_final_ana/audio/screens/send_to_screen.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/field_title.dart';
import '../controller/recorded_audio_handler.dart';

class AuthorTitleCoverScreen extends ConsumerStatefulWidget {
  const AuthorTitleCoverScreen({Key? key}) : super(key: key);
  static const String id = '/author-title-cover';

  @override
  ConsumerState<AuthorTitleCoverScreen> createState() =>
      _AuthorTitleCoverScreenState();
}

class _AuthorTitleCoverScreenState
    extends ConsumerState<AuthorTitleCoverScreen> {
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final List<int> _selectedCoverIndex = [];

  void onNextPressed() {
    String author = _authorNameController.text.trim();
    String title = _titleController.text.trim();
    if (author.isEmpty || title.isEmpty || _selectedCoverIndex.isEmpty) return;
    final recordedAudioHandler = ref.read(recordedAudioHandlerProvider);
    recordedAudioHandler.updateAudioMetadata(
      title: title,
      author: author,
      artUrl: kArtworkUrls[_selectedCoverIndex[0]],
    );
    Navigator.pushNamed(context, SendToScreen.id);
  }

  void onCoverSelect(int index) {
    if (_selectedCoverIndex.isEmpty) {
      _selectedCoverIndex.add(index);
    } else if (_selectedCoverIndex.contains(index)) {
      _selectedCoverIndex.remove(index);
    } else {
      _selectedCoverIndex.clear();
      _selectedCoverIndex.add(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return ScreenBasicStructure(
      appBar: AppBar(
        title: const Text('About your story'),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'btn4',
          backgroundColor: kDarkOrange,
          onPressed: onNextPressed,
          child: const Icon(
            Icons.arrow_forward,
            color: kAntiqueWhite,
          )),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.03,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.87,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
                color: kGreenLight.withOpacity(0.8),
              ),
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  SizedBox(
                      height: 144.0,
                      child: Image.asset(
                          'assets/images/top_right_decoration1.png')),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12.0),
                      const FieldTitle(title: '  Title of the story'),
                      const SizedBox(height: 6.0),
                      TextField(
                        controller: _titleController,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter title'),
                      ),
                      const SizedBox(height: 24.0),
                      const FieldTitle(title: '  Author'),
                      const SizedBox(height: 6.0),
                      TextField(
                        controller: _authorNameController,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter author'),
                      ),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kAntiqueWhite.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18.0),
                      topLeft: Radius.circular(18.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 30.0,
                            child: Image.asset(
                                'assets/images/title_decoration_letf.png'),
                          ),
                          const FieldTitle(
                            title: '  Select a cover',
                            //fontColor: kGreenLight,
                          ),
                          SizedBox(
                            height: 30.0,
                            child: Image.asset(
                                'assets/images/title_decoration_right.png'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 330.0),
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.6),
                          itemCount: kArtworkUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () => onCoverSelect(index),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: CachedNetworkImageProvider(
                                                kArtworkUrls[index])),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12.0,
                                      left: 12.0,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: kAntiqueWhite,
                                        child: Icon(
                                          _selectedCoverIndex.contains(index)
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: kGreenOlivine,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12.0)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
