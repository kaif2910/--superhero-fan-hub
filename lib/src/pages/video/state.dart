part of netflix;

class VideoState extends State<Video> {
  late VideoPlayerController vcontroller;
  late bool controlVisible;
  Timer? timer;
  bool _playingIntro = true;

  @override
  void initState() {
    controlVisible = false; // Hide controls during intro
    vcontroller = VideoPlayerController.asset('assets/video/netflix_intro.mp4')
      ..initialize().then((_) {
        setState(() {});
        vcontroller.play();
      });

    vcontroller.addListener(_introListener);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }

  void _introListener() {
    if (_playingIntro && vcontroller.value.position >= vcontroller.value.duration) {
      vcontroller.removeListener(_introListener);
      _startMainVideo();
    }
  }

  void _startMainVideo() {
    vcontroller.dispose();
    setState(() {
      _playingIntro = false;
      controlVisible = true;
    });

    if (widget.videoUrl.startsWith('http')) {
      vcontroller = VideoPlayerController.network(widget.videoUrl);
    } else {
      vcontroller = VideoPlayerController.asset(
          widget.videoUrl.isNotEmpty ? widget.videoUrl : 'assets/video/promo.mp4');
    }

    vcontroller.initialize().then((_) {
      setState(() {});
      vcontroller.play();
      autoHide();
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    vcontroller.dispose();
    timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void handlerGesture() {
    setState(() {
      controlVisible = !controlVisible;
    });
    autoHide();
  }

  void autoHide() {
    if (controlVisible) {
      timer = Timer(
          Duration(seconds: 5), () => setState(() => controlVisible = false));
    } else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = 0.75;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PlayerLifeCycle(
            vcontroller,
            (BuildContext context, VideoPlayerController controller) =>
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(vcontroller),
                ),
          ),
          GestureDetector(
            child: PlayerControl(
              vcontroller,
              visible: controlVisible,
              title: widget.title,
            ),
            onTap: handlerGesture,
          ),
        ],
      ),
    );
  }
}
