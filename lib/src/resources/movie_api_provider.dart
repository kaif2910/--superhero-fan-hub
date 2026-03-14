part of netflix;

class MovieApiProvider {
  final String host =
      const String.fromEnvironment('NETFLIX_API_HOST', defaultValue: '');
  Client client = Client();

  bool get _useMock => host.isEmpty || host.contains('your-host');

  Future<List<ItemModel>> fetchMovieList() async {
    if (_useMock) {
      return _mockHomeList();
    }

    try {
      final response = await client.get(Uri.parse('$host/api/Home'));
      if (response.statusCode == 200) {
        return List.from(json.decode(response.body))
            .map((m) => ItemModel.fromJson(m))
            .toList();
      }
      throw Exception('Failed to load post');
    } catch (_) {
      return _mockHomeList();
    }
  }

  Future<Result> fetchOne(int id) async {
    if (_useMock) {
      final items = _mockHomeData();
      for (var section in items) {
        final List marvelItems = section['items'];
        for (var item in marvelItems) {
          if (item['id'] == id) {
            return Result.fromJson(item);
          }
        }
      }
      return Result.fromJson(tvShow);
    }

    try {
      final response = await client.get(Uri.parse('$host/api/show/$id'));
      if (response.statusCode == 200) {
        return Result.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to load post');
    } catch (_) {
      return Result.fromJson(tvShow);
    }
  }

  List<ItemModel> _mockHomeList() {
    return _mockHomeData().map((m) => ItemModel.fromJson(m)).toList();
  }

  List<Map<String, dynamic>> _mockHomeData() {
    Map<String, dynamic> createMovie(int id, String name, String poster, String video, String desc) {
      return {
        "id": id,
        "name": name,
        "image": poster,
        "backdrop": poster,
        "videoUrl": video,
        "year": "2022-01-01",
        "details": {
          "genres": ["Action", "Marvel", "Sci-Fi"],
          "description": desc,
          "cast": [{"person": {"name": "Marvel Star"}}],
          "episodes": [
            {
              "id": id,
              "name": "Official Trailer",
              "season": 1,
              "number": 1,
              "runtime": 150,
              "image": poster,
              "summary": "Watch the official trailer for $name."
            }
          ]
        }
      };
    }

    final endgame = createMovie(101, 'Avengers: Endgame', 'assets/images/end_game.jpg', 'assets/video/end_game.mp4', 'After the devastating events of Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to restore balance to the universe.');
    final ironman = createMovie(102, 'Iron Man', 'assets/images/iron_man.jpg', 'assets/video/iron_man.mp4', 'After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil.');
    final spiderman = createMovie(103, 'Spider-Man: No Way Home', 'assets/images/no_way_home.jpg', 'assets/video/no_way_home.mp4', 'With Spider-Man\'s identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear.');
    final thor = createMovie(104, 'Thor: Love and Thunder', 'assets/images/love_and_thunder.jpg', 'assets/video/love_and_thunder.mp4', 'Thor enlists the help of Valkyrie, Korg and ex-girlfriend Jane Foster to fight Gorr the God Butcher, who intends to make the gods extinct.');

    final marvelItems = [endgame, ironman, spiderman, thor];

    return [
      {'title': 'Marvel Cinematic Universe', 'items': marvelItems},
      {'title': 'Trending Now', 'items': [spiderman, endgame, thor, ironman]},
      {'title': 'Action & Adventure', 'items': [ironman, thor, spiderman]},
    ];
  }
}
