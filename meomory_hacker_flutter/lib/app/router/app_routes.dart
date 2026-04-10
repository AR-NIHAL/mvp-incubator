abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const levels = '/levels';
  static const settings = '/settings';
  static const results = '/results';
  static const play = '/play';

  static String playLevel(String levelId) => '$play/$levelId';
  static String resultLevel(String levelId) => '$results/$levelId';
}
