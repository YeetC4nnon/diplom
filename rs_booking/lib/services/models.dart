class Studio {
  late String title;

  Studio({
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
      };

  static Studio fromJson(Map<String, dynamic> json) => Studio(
        title: json['title'],
      );
}
