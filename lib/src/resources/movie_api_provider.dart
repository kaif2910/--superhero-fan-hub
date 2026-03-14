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
    Map<String, dynamic> buildMarvelShow(int id, String name, String poster, String videoUrl, String description) {
      final clone = Map<String, dynamic>.from(tvShow);
      clone['id'] = id;
      clone['name'] = name;
      clone['image'] = poster;
      clone['backdrop'] = poster;
      clone['videoUrl'] = videoUrl;
      clone['year'] = '2022-01-01';
      clone['details']['description'] = description;
      clone['details']['genres'] = ['Action', 'Sci-Fi', 'Marvel'];
      return clone;
    }

    final marvelMovies = [
      {
        'id': 101,
        'name': 'Avengers: Endgame',
        'poster': 'assets/images/end_game.jpg',
        'videoUrl': 'assets/video/end_game.mp4',
        'description': 'After the devastating events of Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to restore balance to the universe.'
      },
      {
        'id': 102,
        'name': 'Iron Man',
        'poster': 'assets/images/iron_man.jpg',
        'videoUrl': 'assets/video/iron_man.mp4',
        'description': 'After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil.'
      },
      {
        'id': 103,
        'name': 'Spider-Man: No Way Home',
        'poster': 'assets/images/no_way_home.jpg',
        'videoUrl': 'assets/video/no_way_home.mp4',
        'description': 'With Spider-Man\'s identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear.'
      },
      {
        'id': 104,
        'name': 'Thor: Love and Thunder',
        'poster': 'assets/images/love_and_thunder.jpg',
        'videoUrl': 'assets/video/love_and_thunder.mp4',
        'description': 'Thor enlists the help of Valkyrie, Korg and ex-girlfriend Jane Foster to fight Gorr the God Butcher, who intends to make the gods extinct.'
      },
    ];

    final marvelItems = marvelMovies.map((m) {
      return buildMarvelShow(
        m['id'] as int,
        m['name'] as String,
        m['poster'] as String,
        m['videoUrl'] as String,
        m['description'] as String,
      );
    }).toList();

    final localPosters = [
      'assets/images/1.jpg',
      'assets/images/2.jpg',
      'assets/images/3.jpg',
      'screenshots/flutter_01.png',
      'screenshots/flutter_02.png',
      'screenshots/flutter_03.png',
      'screenshots/flutter_04.png',
    ];

    final otherItems = List.generate(localPosters.length, (index) {
      final clone = Map<String, dynamic>.from(tvShow);
      clone['id'] = 200 + index;
      clone['name'] = 'Classic ${index + 1}';
      clone['image'] = localPosters[index];
      return clone;
    });

    return [
      {'title': 'Marvel Cinematic Universe', 'items': marvelItems},
      {'title': 'Trending Now', 'items': otherItems},
      {'title': 'New Releases', 'items': otherItems.reversed.toList()},
      {'title': 'Top Picks For You', 'items': marvelItems.reversed.toList()},
    ];
  }
}
