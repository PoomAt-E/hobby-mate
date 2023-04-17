import 'package:shared_preferences/shared_preferences.dart';

class Member {
  int id;
  String name;
  String email;
  String nickname;
  String password;
  int age;
  String address;
  String sex;
  String introduce;
  String profileImgUrl;
  int? interest;
  int? major;
  String userRole;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.password,
    required this.age,
    required this.address,
    required this.sex,
    required this.introduce,
    required this.profileImgUrl,
    this.interest,
    this.major,
    required this.userRole,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        nickname: json["nickname"],
        password: json["password"],
        age: json["age"],
        address: json["address"],
        sex: json['sex'],
        introduce: json["introduce"],
        profileImgUrl: json["profileImgUrl"],
        interest: json["interest"],
        major: json["major"],
        userRole: json["userRole"],
      );

  savePreference(Member member) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('id', member.id);
    pref.setString('email', member.email);
    pref.setString('password', member.password);
    pref.setString('name', member.name);
    pref.setString('address', member.address);
    pref.setString('nickname', member.nickname);
    pref.setInt('age', member.age);
    pref.setString('sex', member.sex);
    pref.setString('profileImgUrl', member.profileImgUrl);
    pref.setString('introduce', member.introduce);
    pref.setString('userRole', member.userRole);
    member.userRole == 'ROLE_USER'
        ? pref.setInt('interest', member.interest!)
        : pref.setInt('major', member.major!);
  }
}
