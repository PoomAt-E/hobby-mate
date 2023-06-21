import 'package:shared_preferences/shared_preferences.dart';

class Member {
  String? name;
  String email;
  String nickname;
  String? password;
  int? age;
  String? address;
  String? addressDetail;
  String? gender;
  String? introduce;
  String? profileImageURL;
  List<String>? interests;
  List<String>? majors;
  String? role;

  Member({
    // required this.id,
     this.name,
    required this.email,
    required this.nickname,
    this.password,
    this.age,
    this.address,
    this.addressDetail,
    this.gender,
    this.introduce,
    this.profileImageURL,
    this.interests,
    this.majors,
    this.role,
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
        gender: json['gender'],
        introduce: json["introduce"],
        profileImageURL: json["profileImageURL"],
        interests: json['interests'] != null
            ? List<String>.from(json['interests'])
            : null,
        majors:
            json['majors'] != null ? List<String>.from(json['majors']) : null,
        role: json["role"],
      );

  savePreference(Member member) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setInt('id', member.id);
    pref.setString('email', member.email);
    pref.setString('nickname', member.nickname);
    pref.setString('role', member.role??"MENTEE");
    // member.userRole == 'ROLE_USER'
    //     ? pref.setInt('interest', member.interest!)
    //     : pref.setInt('major', member.major!);
  }
}
