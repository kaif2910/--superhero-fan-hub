part of marvel_cinema;

class VideoState extends State<Video> {
  late VideoPlayerController vcontroller;
  late bool controlVisible;
  Timer? timer;

  @override
  void initState() {
    controlVisible = true;
    
    if (widget.videoUrl.startsWith('http')) {
      vcontroller = VideoPlayerController.network(widget.videoUrl);
    } else {
      vcontroller = VideoPlayerController.asset(
          widget.videoUrl.isNotEmpty ? widget.videoUrl : 'assets/video/app_intro.mp4');
    }

    vcontroller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      vcontroller.play();
      autoHide();
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
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
