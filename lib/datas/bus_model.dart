class Bus {
  String busName;
  List<String> routes;
  List<String?>? times;

  Bus({
    required this.busName,
    required this.routes,
    this.times,
  });
}