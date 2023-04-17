class Vod {
  String id;
  String ownerId;
  String vodGroupId;
  String vodName;
  String vodType;
  String vodUrl;
  int vodLengthH;
  int vodLengthM;
  int vodLengthS;

  Vod(
      {required this.id,
      required this.ownerId,
      required this.vodGroupId,
      required this.vodLengthH,
      required this.vodLengthM,
      required this.vodLengthS,
      required this.vodName,
      required this.vodType,
      required this.vodUrl});
}

class VodGroup {
  String id;
  String ownerId;
  String vodGroupName;
  int vodNumber;

  VodGroup(
      {required this.id,
      required this.ownerId,
      required this.vodGroupName,
      required this.vodNumber});
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
