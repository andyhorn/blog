/// A project to display on the portfolio homepage.
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.url,
    required this.tags,
  });

  final String title;
  final String description;
  final String url;
  final List<String> tags;
}
