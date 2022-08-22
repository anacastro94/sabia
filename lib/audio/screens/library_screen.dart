import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // TODO: Connect to the database

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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text(
              'Recently shared with you',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: kBlackOlive,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            height: 150.0,
            child: PageView.builder(
                //TODO: Get list from database
                controller: PageController(viewportFraction: 0.8),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(18.0),
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image:
                                AssetImage('assets/images/covers/c$index.png')),
                      ),
                    ),
                  );
                }),
          ),
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
                children: [
                  ListView.builder(
                      itemCount: 11,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            color: kAntiqueWhite,
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
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: AssetImage(
                                                'assets/images/covers/c$index.png')),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Story title',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: kBlackOlive),
                                          ),
                                          Text(
                                            'Sender Name',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: kGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons
                                                    .download_for_offline_outlined,
                                                color: kBlackOlive,
                                              )),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.fiber_new,
                                              color: kDarkOrange,
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
                      }),
                  const Text(
                    '2',
                    style: TextStyle(color: kBlackOlive),
                  ),
                  const Text(
                    '3',
                    style: TextStyle(color: kBlackOlive),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
