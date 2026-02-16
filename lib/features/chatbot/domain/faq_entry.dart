class FaqEntry {
  final String id;
  final String question;
  final String answer;
  final List<String> tags;

  FaqEntry({
    required this.id,
    required this.question,
    required this.answer,
    required this.tags,
  });
}
