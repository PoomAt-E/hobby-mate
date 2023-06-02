class Post {
  final int id;
  final String title;
  final String content;
  final String location;
  final String createdAt;
  final int userId;
  final List<Comment> comments;
  final int views;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.createdAt,
    required this.comments,
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
      comments: json['comments'] !=null?List<Comment>.from(json['comments']):[],
      userId: json['userId'],
      views: json['views'],
    );
  }
}

class Comment {
  String content;
  String date;
  String id;

  Comment({required this.content, required this.date, required this.id});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'],
      date: json['date'],
      id: json['id'],
    );
  }
}
