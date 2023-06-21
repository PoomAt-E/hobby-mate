class Board {
  final String boardId;
  final String title;
  final String content;
  final String location;
  final String userId;
  final List<String> comments;
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
      comments:
          json['comments'] != null ? List<String>.from(json['comments']) : [],
      userId: json['userId'],
      views: json['views'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'location': location,
        'userId': userId,
        'views': views,
      };
}

class Comment {
  String boardId;
  List<String>? childList;
  String content;
  int good;
  String id;
  String userId;

  Comment({
    required this.boardId,
    this.childList,
    required this.content,
    required this.good,
    required this.id,
    required this.userId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      boardId: json['boardId'],
      childList: json['childList'] != null
          ? List<String>.from(json['childList'])
          : null,
      content: json['content'],
      good: json['good'],
      id: json['id'],
      userId: json['userId'],
    );
  }
}
