part of marvel_cinema;

class FilterState extends State<Filter> {
  late String filterSelected;
  List<String> options = ['Series', 'Movies', 'My List'];
  dynamic tvShow = {
    "details": {
      "genres": ["Drama", "Crime"],
      "year": "2011-09-20",
      "description":
          "Unforgettable follows Carrie Wells, an enigmatic former police detective with a rare condition that makes her memory so flawless that every place, every conversation, every moment of joy and every heartbreak is forever embedded in her mind."
    },
    "_id": "5bedbf00a70245f2bbdd6a64",
    "id": 89,
    "name": "Unforgettable",
    "image":
        "assets/images/2.jpg"
  };
  @override
  void initState() {
    filterSelected = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          primary: true,
          expandedHeight: screenSize.height * 0.65,
          backgroundColor: Colors.black,
          leading: Image.asset('assets/images/app_icon.png'),
          // titleSpacing: 20.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: widget.type,
                child: TextButton(
                  onPressed: () => print(widget.type),
                  child: Text(
                    widget.type.replaceAll('-', ' '),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  mediaImage(tvShow['image'], fit: BoxFit.cover),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}



