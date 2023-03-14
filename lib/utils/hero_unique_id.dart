class HeroUniqueId {
  static int _id = 0;
  static String get() {
    _id++;
    return "hero-$_id";
  }
}
