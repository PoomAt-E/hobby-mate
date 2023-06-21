class MatchingRequest {
  bool isMentor;
  String menteeEmail;
  String mentorEmail;
  bool mentor;
  String matchDate;

  MatchingRequest({
    required this.menteeEmail,
    required this.mentorEmail,
    required this.matchDate,
    required this.isMentor,
    required this.mentor,
  });
  factory MatchingRequest.fromJson(Map<String, dynamic> json) {
    return MatchingRequest(
      menteeEmail: json['menteeEmail'],
      mentorEmail: json['mentorEmail'],
      matchDate: json['matchDate'],
      isMentor: json['isMentor'],
      mentor: json['mentor'],
    );
  }
}