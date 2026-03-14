part of netflix;

class SplashState extends State<Home> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    
    // Fallback timer: Go to Home after 6 seconds no matter what
    _fallbackTimer = Timer(Duration(seconds: 6), _goToHome);

    _controller = VideoPlayerController.asset('assets/video/promo.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.setVolume(0.0); // Mute for autoplay
        setState(() {
          _initialized = true;
        });
        _controller.play();
      }).catchError((error) {
        print("Video play error: $error");
        _goToHome();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration && _controller.value.duration != Duration.zero) {
        _goToHome();
      }
    });
  }

  void _goToHome() {
    if (!mounted) return;
    _fallbackTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainHome(title: widget.title)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fallbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: _initialized
            ? FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
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

