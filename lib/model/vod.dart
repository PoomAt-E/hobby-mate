class VodGroup {
  String id;
  String? ownerId;
  String vodGroupName;
  int vodCount;
  String thumbnailURL;
  String? keyword;
  List<Vod>? vodList = [];

  VodGroup(
      {required this.id,
      this.ownerId,
      required this.vodGroupName,
      required this.vodCount,
      required this.thumbnailURL, this.keyword,
      this.vodList});

  factory VodGroup.fromJson(Map<String, dynamic> json) {
    return VodGroup(
      id: json['id'],
      ownerId: json['ownerId'],
      vodGroupName: json['vodGroupName'],
      vodCount: json['vodCount'],
      thumbnailURL: json['thumbnailURL'],
      keyword: json['keyword'],
      vodList: json['vodlist'] != null?json['vodlist']
          .map((json) => Vod.fromJson(json))
          .cast<Vod>()
          .toList(): null,

    );
  }
}

class Vod {
  int idx;
  String title;
  String description;
  String thumbnailURL;
  String vodURL;
  String key;

  Vod(
      {required this.idx,
      required this.title,
      required this.description,
      required this.thumbnailURL,
      required this.vodURL,
      required this.key});

  factory Vod.fromJson(Map<String, dynamic> json) => Vod(
    idx: json['idx'],
    title: json['title'],
    description: json['description'],
    thumbnailURL: json['thumbnailURL'],
    vodURL: json['vodURL'],
    key: json['key'],
  );
}

class VodView {
  String id;
  String userId;
  String vodGroupId;
  String vodId;
  int viewH;
  int viewM;
  int viewS;

  VodView({
    required this.id,
    required this.userId,
    required this.vodGroupId,
    required this.vodId,
    required this.viewH,
    required this.viewM,
    required this.viewS,
  });
}

class VodAuthority {
  String id;
  String userId;
  String vodGroupId;
  String dayStart;
  String dayExpire;

  VodAuthority(
      {required this.id,
      required this.userId,
      required this.vodGroupId,
      required this.dayStart,
      required this.dayExpire});
}
