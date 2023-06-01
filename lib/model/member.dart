import 'package:shared_preferences/shared_preferences.dart';

class Member {
  // int? id;
  String name;
  String email;
  String nickname;
  String password;
  int age;
  String address;
  String addressDetail;
  String sex;
  String introduce;
  String profileImageURL;
  List<String>? interests;
  List<String>? majors;
  String role;

  Member({
    // required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.password,
    required this.age,
    required this.address,
    required this.addressDetail,
    required this.sex,
    required this.introduce,
    required this.profileImageURL,
    this.interests,
    this.majors,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        // id: json["id"],
        name: json["name"],
        email: json["email"],
        nickname: json["nickname"],
        password: json["password"],
        age: json["age"],
        address: json["address"],
        addressDetail: json["addressDetail"],
        sex: json['sex'],
        introduce: json["introduce"],
        profileImageURL: json["profileImageURL"],
        interests: json['interests'] !=null?List<String>.from(json['interests']):null,
        majors: json['majors'] !=null?List<String>.from(json['majors']):null,
        role: json["role"],
      );

  savePreference(Member member) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setInt('id', member.id);
    pref.setString('email', member.email);
    pref.setString('password', member.password);
    pref.setString('name', member.name);
    pref.setString('address', member.address);
    pref.setString('nickname', member.nickname);
    pref.setInt('age', member.age);
    pref.setString('sex', member.sex);
    pref.setString('profileImageURL', member.profileImageURL);
    pref.setString('introduce', member.introduce);
    pref.setString('role', member.role);
    // member.userRole == 'ROLE_USER'
    //     ? pref.setInt('interest', member.interest!)
    //     : pref.setInt('major', member.major!);
  }
}
