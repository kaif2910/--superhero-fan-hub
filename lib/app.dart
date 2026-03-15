library marvel_cinema;

// Dart Imports
import 'dart:async';
import 'dart:convert';

// Flutter imports
import 'package:http/http.dart' show Client;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Plugins import...
import 'package:fluro/fluro.dart';
import 'package:video_player/video_player.dart';

// Router
part 'src/helpers/config/constants.dart';
part 'src/helpers/config/application.dart';
part 'src/helpers/config/routes.dart';
part 'src/helpers/config/route_handlers.dart';

// Models
part 'src/models/episode.dart';
part 'src/models/result.dart';
part 'src/models/item_model.dart';

// Blocs
part 'src/blocs/movies_bloc.dart';

// Resources
part 'src/resources/movie_api_provider.dart';
part 'src/resources/repository.dart';

part 'src/utils/theme/color.dart';
part 'src/utils/theme/typography.dart';
part 'src/utils/local_store.dart';
part 'src/pages/video/index.dart';
part 'src/pages/video/state.dart';
part 'src/pages/home/index.dart';
part 'src/pages/home/state.dart';
part 'src/pages/summary/index.dart';
part 'src/pages/summary/state.dart';
part 'src/pages/filter/index.dart';
part 'src/pages/filter/state.dart';
part 'src/pages/detail/index.dart';
part 'src/pages/detail/state.dart';

// Widgets
part 'src/widgets/tvshow-list/index.dart';
part 'src/widgets/media_image.dart';
part 'src/widgets/player-life-cycle/index.dart';
part 'src/widgets/player-life-cycle/state.dart';
part 'src/widgets/player-controls/index.dart';
part 'src/widgets/player-controls/state.dart';

class MarvelCinema extends StatelessWidget {
  MarvelCinema({Key? key}) : super(key: key) {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hero Universe',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: Application.router.generator,
      home: Home(title: 'Home'),
    );
  }
}
