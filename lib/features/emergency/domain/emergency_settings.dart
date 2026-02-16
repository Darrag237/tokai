class EmergencySettings {
  final String messageTemplate;
  final List<String> targets;

  EmergencySettings({required this.messageTemplate, required this.targets});

  EmergencySettings copyWith({String? messageTemplate, List<String>? targets}) {
    return EmergencySettings(
      messageTemplate: messageTemplate ?? this.messageTemplate,
      targets: targets ?? this.targets,
    );
  }

  static EmergencySettings defaults() => EmergencySettings(
        messageTemplate: 'أنا بحاجة للمساعدة. هذا بلاغ طارئ من تطبيق Tokai.',
        targets: const ['16528', '01555516528', '01229869384'],
      );
}
