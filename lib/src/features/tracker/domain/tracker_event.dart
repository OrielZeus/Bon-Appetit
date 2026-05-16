class TrackerEvent {
  const TrackerEvent({
    required this.title,
    required this.detail,
    required this.isDone,
  });

  final String title;
  final String detail;
  final bool isDone;
}
