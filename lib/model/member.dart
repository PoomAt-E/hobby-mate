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
  String profile_img_url;
  int? interest;
  int? major;
  String user_role;

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
    required this.profile_img_url,
    this.interest,
    this.major,
    required this.user_role,
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
        profile_img_url: json["profile_img_url"],
        interest: json["interest"],
        major: json["major"],
        user_role: json["user_role"],
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
    pref.setString('profile_img_url', member.profile_img_url);
    pref.setString('introduce', member.introduce);
    pref.setString('user_role', member.user_role);
    member.user_role == 'ROLE_USER'
        ? pref.setInt('interest', member.interest!)
        : pref.setInt('major', member.major!);
  }
}
