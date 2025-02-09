import 'dart:convert';
import 'dart:io';

class AddDonPost {
  final String name;
  final String dontype;
  final String age;
  final String gender;
  final String availability;
  final String location;
  final String content;
  final int userid;

  AddDonPost({
    required this.name,
    required this.dontype,
    required this.age,
    required this.gender,
    required this.availability,
    required this.location,
    required this.content,
    required this.userid,
  });

  factory AddDonPost.fromJson(Map<String, dynamic> json) {
    return AddDonPost(
      name: json['name'],
      dontype: json['dontype'],
      age: json['age'],
      gender: json['gender'],
      availability: json['availability'],
      location: json['location'],
      content: json['content'],
      userid: json['user_id'],
    );
  }
}
