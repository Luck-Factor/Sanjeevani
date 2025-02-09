import 'dart:convert';
import 'dart:io';

class AddReqPost {
  final String name;
  final String reqtype;
  final String age;
  final String gender;
  final String urgency;
  final String location;
  final String content;
  final int userid;

  AddReqPost({
    required this.name,
    required this.reqtype,
    required this.age,
    required this.gender,
    required this.urgency,
    required this.location,
    required this.content,
    required this.userid,
  });

  factory AddReqPost.fromJson(Map<String, dynamic> json) {
    return AddReqPost(
      name: json['name'],
      reqtype: json['reqtype'],
      age: json['age'],
      gender: json['gender'],
      urgency: json['urgency'],
      location: json['location'],
      content: json['content'],
      userid: json['user_id'],
    );
  }
}
