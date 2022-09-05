import 'package:bbk_final_ana/audio/controller/player_controller.dart';
import 'package:bbk_final_ana/audio/screens/player_screen.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/common/widgets/standard_circular_progress_indicator.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../../models/audio_metadata.dart';
import '../enums/library_filters_enum.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);
  static const String id = '/library';

  @override
  ConsumerState<LibraryScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackOlive),
        backgroundColor: kGreenLight,
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LibraryMainTitle(title: 'Recently shared with you'),
          const SizedBox(height: 12.0),
          const RecentlySharedPageView(),
          Expanded(
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, isScroll) => [
                SliverAppBar(
                  backgroundColor: kGreenLight,
                  actions: const [SizedBox()],
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size.zero,
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      child: TabBar(
                          indicatorPadding: const EdgeInsets.all(12.0),
                          unselectedLabelStyle:
                              const TextStyle(fontWeight: FontWeight.w400),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: kGreenOlivine,
                          controller: _tabController,
                          isScrollable: false,
                          labelColor: kDarkOrange,
                          unselectedLabelColor: kGrey,
                          labelStyle: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(
                              text: 'All',
                            ),
                            Tab(
                              text: 'Favorites',
                            ),
                            Tab(
                              text: 'Yours',
                            ),
                          ]),
                    ),
                  ),
                )
              ],
              body: TabBarView(
                controller: _tabController,
                children: const [
                  AudiosListView(filter: LibraryFiltersEnum.all),
                  AudiosListView(filter: LibraryFiltersEnum.favorites),
                  AudiosListView(filter: LibraryFiltersEnum.yours),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudiosListView extends ConsumerWidget {
  const AudiosListView({
    Key? key,
    required this.filter,
  }) : super(key: key);
  final LibraryFiltersEnum filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.watch(audioPlayerControllerProvider);
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder<List<AudioMetadata>>(
        stream: playerController.getAudioMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: StandardCircularProgressIndicator(),
            );
          }
          final filteredAudioList = snapshot.data!.where((audioMetadata) {
            switch (filter) {
              case LibraryFiltersEnum.favorites:
                return (audioMetadata.senderId !=
                        firebaseAuth.currentUser!.uid) &&
                    (audioMetadata.isFavorite);
              case LibraryFiltersEnum.yours:
                return audioMetadata.senderId == firebaseAuth.currentUser!.uid;
              default:
                return audioMetadata.senderId != firebaseAuth.currentUser!.uid;
            }
          }).toList();
          return ListView.builder(
              itemCount: filteredAudioList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var audioMetadata = filteredAudioList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AudioInformationCard(audioMetadata: audioMetadata),
                );
              });
        });
  }
}

class AudioInformationCard extends ConsumerWidget {
  const AudioInformationCard({
    Key? key,
    required this.audioMetadata,
  }) : super(key: key);

  final AudioMetadata audioMetadata;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Card(
      color: kAntiqueWhite,
      child: InkWell(
        onTap: () {
          playerController.playSelectedAudio(audioMetadata);
          if (!audioMetadata.isSeen) {
            playerController.setAudioMessageSeen(
              context: context,
              senderId: audioMetadata.senderId,
              messageId: audioMetadata.id,
            );
          }
          Navigator.pushNamed(context, PlayerScreen.id);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  height: 120.0,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image:
                            CachedNetworkImageProvider(audioMetadata.artUrl)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audioMetadata.title,
                        textAlign: TextAlign.start,
                        style:
                            const TextStyle(fontSize: 20.0, color: kBlackOlive),
                      ),
                      Text(
                        audioMetadata.author,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      StreamBuilder<UserModel>(
                          stream: ref
                              .watch(authControllerProvider)
                              .getUserDataById(audioMetadata.senderId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'by ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 18.0,
                                  color: kGrey,
                                ),
                              );
                            }
                            final senderName = snapshot.data!.name;
                            return Text(
                              'by $senderName',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: 'DancingScript',
                                fontSize: 18.0,
                                color: kGrey,
                              ),
                            );
                          }),
                    ],
                  ),
                  audioMetadata.senderId == firebaseAuth.currentUser!.uid
                      ? const SizedBox()
                      : Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  playerController.toggleAudioMessageFavorite(
                                context,
                                audioMetadata.senderId,
                                audioMetadata.id,
                              ),
                              icon: Icon(
                                audioMetadata.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                            // Uncomment to implement the possibility to download
                            // IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(
                            //       Icons.download_for_offline_outlined,
                            //       color: kBlackOlive,
                            //     )),
                            audioMetadata.isSeen
                                ? const SizedBox()
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.fiber_new,
                                      color: kGreenOlivine,
                                    ),
                                  ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecentlySharedPageView extends ConsumerWidget {
  const RecentlySharedPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.watch(audioPlayerControllerProvider);
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder<List<AudioMetadata>>(
        stream: playerController.getAudioMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: StandardCircularProgressIndicator(),
            );
          }
          final filteredAudioList = snapshot.data!
              .where((audioMetadata) =>
                  audioMetadata.senderId != firebaseAuth.currentUser!.uid)
              .toList();

          return SizedBox(
            height: 150.0,
            child: PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                itemCount: filteredAudioList.take(5).length,
                itemBuilder: (context, index) {
                  var audioMetadata = filteredAudioList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        playerController.playSelectedAudio(audioMetadata);
                        if (!audioMetadata.isSeen) {
                          playerController.setAudioMessageSeen(
                            context: context,
                            senderId: audioMetadata.senderId,
                            messageId: audioMetadata.id,
                          );
                        }
                        Navigator.pushNamed(context, PlayerScreen.id);
                      },
                      child: Container(
                        height: 180.0,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(18.0),
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: CachedNetworkImageProvider(
                                  audioMetadata.artUrl)),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}

class LibraryMainTitle extends StatelessWidget {
  const LibraryMainTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w400,
          color: kBlackOlive,
          fontFamily: 'DancingScript',
        ),
      ),
    );
  }
}
