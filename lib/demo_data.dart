class DemoItem {
  final String id;
  final String title;
  final String description;
  final String icon;

  const DemoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<DemoItem> demoItems = [
  DemoItem(
    id: "1",
    title: "AI Assistant",
    description: "Smart assistant powered by AI to help students instantly.",
    icon: "assistant",
  ),
  DemoItem(
    id: "2",
    title: "Task Manager",
    description: "Organize, track and manage your daily tasks easily.",
    icon: "task",
  ),
  DemoItem(
    id: "3",
    title: "Analytics",
    description: "Real-time performance tracking and smart insights.",
    icon: "analytics",
  ),
];
