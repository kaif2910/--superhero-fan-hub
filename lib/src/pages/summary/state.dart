part of netflix;

class SummaryState extends State<Summary> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  Set<int> _myListIds = {};
  Map<int, double> _progress = {};

  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
    _loadLocalState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalState() async {
    final list = await LocalStore.getMyList();
    final progress = await LocalStore.getProgress();
    if (!mounted) return;
    setState(() {
      _myListIds = list;
      _progress = progress;
    });
  }

  Future<void> _toggleMyList(int id) async {
    final next = Set<int>.from(_myListIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    setState(() => _myListIds = next);
    await LocalStore.setMyList(next);
  }

  Future<void> _updateProgress(int id, double value) async {
    final next = Map<int, double>.from(_progress);
    next[id] = value.clamp(0.0, 1.0);
    setState(() => _progress = next);
    await LocalStore.setProgress(next);
  }

  String _heroImageForTab(String title) {
    switch (title) {
      case 'Search':
        return 'screenshots/flutter_02.png';
      case 'Coming Soon':
        return 'screenshots/flutter_03.png';
      case 'Downloads':
        return 'screenshots/flutter_04.png';
      case 'More':
        return 'screenshots/flutter_01.png';
      default:
        return 'assets/images/1.jpg';
    }
  }

  Widget _buildGallerySection(String title, List<String> images,
      {double height = 160.0}) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: images.map((img) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  width: 220.0,
                  height: height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: mediaImage(img, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 30, 30, 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white70),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white54, fontSize: 12.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopTenRow(List<Result> items) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(185, 3, 12, 1.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'TOP 10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  'Movies in India Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(items.length.clamp(0, 10), (index) {
                return Container(
                  margin: EdgeInsets.only(right: 10.0, left: index == 0 ? 8.0 : 0),
                  width: 130.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 68.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: GestureDetector(
                            onTap: () => goToDetail(items[index], 99),
                            child: mediaImage(
                              items[index].image,
                              fit: BoxFit.cover,
                              width: 90.0,
                              height: 135.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueRow(List<Result> items) {
    final take = items.take(4).toList();
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Continue Watching',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(take.length, (index) {
                final item = take[index];
                final progress = _progress[item.id] ?? (0.15 * (index + 1));
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  width: 220.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: GestureDetector(
                          onTap: () => _updateProgress(
                            item.id,
                            (progress + 0.12).clamp(0.0, 1.0),
                          ),
                          child: mediaImage(
                            item.image,
                            fit: BoxFit.cover,
                            height: 120.0,
                            width: 220.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        height: 3.0,
                        width: 220.0,
                        color: Colors.white24,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 220.0 * progress,
                            color: Color.fromRGBO(185, 3, 12, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void goTo(String type) {
    Application.router.navigateTo(
      context,
      '${Routes.filter.replaceAll(':title', 'Filter').replaceAll(':type', type)}',
      transition: TransitionType.nativeModal,
      routeSettings: RouteSettings(arguments: {'type': type, 'title': 'Filter'}),
    );
  }

  void goToDetail(Result item, int match) {
    Application.router.navigateTo(
      context,
      Routes.detail.replaceAll(':item', item.id.toString()),
      transition: TransitionType.inFromRight,
      routeSettings: RouteSettings(arguments: {'match': match, 'show': item}),
    );
  }

  void showTrailer(Result show) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]).then((e) {
      _updateProgress(show.id, (_progress[show.id] ?? 0.0) + 0.15);
      Application.router.navigateTo(
        context,
        Routes.video.replaceAll(':title', show.name),
        routeSettings: RouteSettings(arguments: {
          'title': show.name,
          'videoUrl': show.videoUrl
        }),
        transition: TransitionType.inFromBottom,
      );
    });
  }

  List<Widget> renderMainGenres(Result show) {
    List<Widget> genres = List<Widget>.from(show.genres.map((g) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          g,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
      );
    }).toList());
    return genres;
  }

  Widget renderTitle(String tag, String text) {
    return Hero(
      tag: tag,
      child: TextButton(
        onPressed: () => goTo(tag),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(25, 25, 25, 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.white70),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search titles, genres, people',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (_query.isNotEmpty)
                  IconButton(
                    onPressed: () => _searchController.clear(),
                    icon: Icon(Icons.close, color: Colors.white70),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _chip('Action'),
                _chip('Drama'),
                _chip('Crime'),
                _chip('Thriller'),
                _chip('Sci-Fi'),
                _chip('Comedy'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: EdgeInsets.only(right: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(40, 40, 40, 1.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white70, fontSize: 12.0),
      ),
    );
  }

  List<Result> _flattenResults(List<ItemModel> data) {
    final List<Result> out = [];
    for (final section in data) {
      out.addAll(section.results);
    }
    return out;
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final String heroImage = _heroImageForTab(widget.title);
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final allResults = _flattenResults(data);
          
          // Use the first item from the first section as our Hero, or fallback to constants
          final Result heroShow = allResults.isNotEmpty 
              ? allResults.first 
              : Result.fromJson(json.decode(json.encode(tvShow))); 
          
          final List<Widget> sections = <Widget>[];
          if (widget.title != 'Search') {
            for (final section in data) {
              sections.add(
                ShowsList(
                  items: section.results,
                  onTap: goToDetail,
                  title: section.title,
                ),
              );
            }
          }

          if (widget.title == 'Search') {
            sections.add(_buildSearchHeader());
            if (_query.isNotEmpty) {
              final filtered = allResults
                  .where((r) =>
                      r.name.toLowerCase().contains(_query.toLowerCase()))
                  .toList();
              if (filtered.isEmpty) {
                sections.add(_buildInfoCard(
                  'No Results',
                  'Try a different title, genre, or person.',
                  Icons.search_off,
                ));
              } else {
                sections.add(
                  ShowsList(
                    items: filtered,
                    onTap: goToDetail,
                    title: 'Results',
                  ),
                );
              }
            } else {
              sections.add(_buildInfoCard(
                'Top Searches',
                'Explore trending titles and genres.',
                Icons.trending_up,
              ));
            }
          }

          if (widget.title == 'Coming Soon') {
            sections.add(_buildGallerySection('Sneak Peek', [
              'screenshots/flutter_01.png',
              'screenshots/flutter_02.png',
              'screenshots/flutter_03.png',
            ]));
          }

          if (widget.title == 'Home') {
            sections.insert(0, _buildContinueRow(allResults));
            sections.insert(0, _buildTopTenRow(allResults));
            final myListItems =
                allResults.where((r) => _myListIds.contains(r.id)).toList();
            if (myListItems.isNotEmpty) {
              sections.insert(
                0,
                ShowsList(
                  items: myListItems,
                  onTap: goToDetail,
                  title: 'My List',
                ),
              );
            }
          }

          if (widget.title == 'Downloads') {
            sections.add(_buildInfoCard(
              'Smart Downloads',
              'New episodes will be saved automatically for you.',
              Icons.download_done,
            ));
            sections.add(_buildGallerySection('Downloaded For You', [
              'assets/images/2.jpg',
              'assets/images/3.jpg',
              'screenshots/flutter_04.png',
            ]));
          }

          if (widget.title == 'More') {
            final List<String> assetsGallery = [
              'assets/images/1.jpg',
              'assets/images/2.jpg',
              'assets/images/3.jpg',
              'assets/images/end_game.jpg',
              'assets/images/iron_man.jpg',
              'assets/images/no_way_home.jpg',
              'assets/images/love_and_thunder.jpg',
              'assets/images/Netflix-logo.png',
              'assets/images/user.png',
            ];

            sections.add(
              _buildGallerySection('App Assets', assetsGallery, height: 120),
            );
            sections.add(_buildInfoCard(
              'Profile',
              'Switch profiles and manage your account settings.',
              Icons.person,
            ));
          }
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                primary: true,
                expandedHeight: screenSize.height * 0.62,
                backgroundColor: Colors.black,
                leading: Image.asset('assets/images/netflix_icon.png'),
                titleSpacing: 20.0,
                title: widget.title == 'Home'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/Netflix-logo.png',
                            height: 22.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.cast, color: Colors.white),
                              SizedBox(width: 16.0),
                              Icon(Icons.search, color: Colors.white),
                              SizedBox(width: 16.0),
                              CircleAvatar(
                                radius: 12.0,
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          renderTitle('Series', 'Series'),
                          renderTitle('Movies', 'Movies'),
                          renderTitle('My-list', 'My List'),
                        ],
                      ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        widget.title == 'Home'
                            ? HeroVideo()
                            : mediaImage(heroImage, fit: BoxFit.cover),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.1, 0.6, 1.0],
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black
                              ],
                            ),
                          ),
                          child: Container(
                            height: 40.0,
                            width: screenSize.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 3.0,
                                          color:
                                              Color.fromRGBO(185, 3, 12, 1.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      heroShow.name.replaceAll(' ', '\n'),
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        height: 0.65,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: renderMainGenres(heroShow),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(
                                              _myListIds.contains(heroShow.id)
                                                  ? Icons.check
                                                  : Icons.add,
                                            ),
                                            Text(
                                              _myListIds.contains(heroShow.id)
                                                  ? 'Added'
                                                  : 'My List',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => _toggleMyList(heroShow.id),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.play_arrow),
                                            Text(
                                              'Play',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => showTrailer(heroShow),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.info_outline),
                                            Text(
                                              'Info',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => goToDetail(heroShow, 99),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(sections),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromRGBO(219, 0, 0, 1.0)),
        ));
      },
    );
  }
}

class HeroVideo extends StatefulWidget {
  @override
  _HeroVideoState createState() => _HeroVideoState();
}

class _HeroVideoState extends State<HeroVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/end_game.mp4');
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.initialize().then((_) {
      if (!mounted) return;
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return mediaImage('assets/images/end_game.jpg', fit: BoxFit.cover);
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}




