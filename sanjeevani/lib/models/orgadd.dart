import 'dart:convert';
import 'dart:io';

class OrgAdd {
  final String organ_name;
  final String blood_type;
  final String hla_markers;
  final String condition;
  final int hospital_id;
  final double longitude;
  final double latitude;

  OrgAdd({
    required this.organ_name,
    required this.blood_type,
    required this.hla_markers,
    required this.condition,
    required this.hospital_id,
    required this.latitude,
    required this.longitude
  });

  factory OrgAdd.fromJson(Map<String, dynamic> json) {
    return OrgAdd(
      organ_name: json['organ_name'],
      blood_type: json['blood_type'],
      hla_markers: json['hla_markers'],
      condition: json['condition'],
      hospital_id: json['hospital_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
