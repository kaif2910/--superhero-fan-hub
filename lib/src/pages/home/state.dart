part of netflix;

class SplashState extends State<Home> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/netflix_intro.mp4')
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainHome(title: widget.title)),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}

class HomeState extends State<MainHome> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    controller = TabController(length: 5, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: TabBar(
        labelStyle: TextStyle(fontSize: 10.0),
        indicatorWeight: 0.1,
        controller: controller,
        tabs: <Widget>[
          Tab(text: 'Home', icon: Icon(Icons.home)),
          Tab(text: 'Search', icon: Icon(Icons.search)),
          Tab(text: 'Coming Soon', icon: Icon(Icons.ondemand_video)),
          Tab(text: 'Downloads', icon: Icon(Icons.file_download)),
          Tab(text: 'More', icon: Icon(Icons.menu)),
        ],
      ),
      body: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Summary(title: 'Home'),
          Summary(title: 'Search'),
          Summary(title: 'Coming Soon'),
          Summary(title: 'Downloads'),
          Summary(title: 'More'),
        ],
      ),
    );
  }
}

