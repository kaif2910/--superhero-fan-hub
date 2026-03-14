part of netflix;

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  SplashState createState() => SplashState();
}

class MainHome extends StatefulWidget {
  MainHome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  HomeState createState() => HomeState();
}
