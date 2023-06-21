class Board {
  final int boardId;
  final String title;
  final String content;
  final String location;
  final int userId;
  final List<Comment> comments;
  final int views;

  Board({
    required this.boardId,
    required this.title,
    required this.content,
    required this.location,
    required this.comments,
    required this.userId,
    required this.views,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      boardId: json['boardId'],
      title: json['title'],
      content: json['content'],
      location: json['location'],
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
