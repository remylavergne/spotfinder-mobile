class Throttling {
  Duration _duration;
  bool _isAvailable = true;

  Throttling(Duration duration) {
    this._duration = duration;
  }

  dynamic throttle(Function func) async {
    if (!_isAvailable) return null;
    this._isAvailable = false;

    Future.delayed(this._duration).then((value) {
      this._isAvailable = true;
    });

    return Function.apply(func, []);
  }
}
