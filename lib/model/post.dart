class Post {
  final int id;
  final String title;
  final String content;
  final String location;
  final String createdAt;
  final int userId;
  final int views;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.createdAt,
    required this.userId,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      location: json['location'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      views: json['views'],
    );
  }
}
