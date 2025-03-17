// Timer Model (Represents a single timer instance)
class ChronoModel {
  String name;
  Duration duration;
  bool isRunning;

  ChronoModel({
    required this.name,
    required this.duration,
    this.isRunning = false,
  });
}