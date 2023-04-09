class Post {
  final int id;
  final String title;
  final String content;
  final String location;
  final String created_at;
  final int user_id;
  final int views;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.created_at,
    required this.user_id,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      location: json['location'],
      created_at: json['created_at'],
      user_id: json['user_id'],
      views: json['views'],
    );
  }
}
