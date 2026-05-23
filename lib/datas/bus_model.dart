class Bus {
  final String busName;
  final List<String> routes;
  final List<String?>? times;

  const Bus({
    required this.busName,
    required this.routes,
    this.times,
  });
}
