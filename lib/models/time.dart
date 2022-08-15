class Time {
  int hours;
  int minutes;
  int seconds;

  Time.fromSeconds(int durationInSeconds)
      : assert(durationInSeconds >= 0),
        hours = durationInSeconds ~/ 3600,
        minutes = (durationInSeconds % 3600) ~/ 60,
        seconds = (durationInSeconds % 3600) % 60;

  @override
  String toString() {
    late String timeToString;
    hours > 9 ? timeToString = '$hours:' : timeToString = '0$hours:';
    minutes > 9 ? timeToString += '$minutes:' : timeToString += '0$minutes:';
    seconds > 9 ? timeToString += '$seconds' : timeToString += '0$seconds';
    return timeToString;
  }
}
