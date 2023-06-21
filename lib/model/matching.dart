class Matching{
  final String matchId;
  final String mentorEmail;
  final String menteeEmail;
  final int matchDate;
  final bool mentorOk;
  final bool menteeOk;

  Matching({
    required this.matchId,
    required this.mentorEmail,
    required this.menteeEmail,
    required this.matchDate,
    required this.mentorOk,
    required this.menteeOk,
  });

  factory Matching.fromJson(Map<String, dynamic> json) {
    return Matching(
      matchId: json['matchId'],
      mentorEmail: json['mentorEmail'],
      menteeEmail: json['menteeEmail'],
      matchDate: json['matchDate'],
      mentorOk: json['mentorOk'],
      menteeOk: json['menteeOk'],
    );
  }
}