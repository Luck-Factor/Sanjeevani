import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sanjeevani/models/reqpostadd.dart';

class ApiService {
  final String baseUrl;

  ApiService(
      {this.baseUrl = 'http://127.0.0.1:8000'}); // Replace with your API URL

  Future<List<AddReqPost>> fetchRequests({int skip = 0, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_all_requests?skip=$skip&limit=$limit'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((post) => AddReqPost.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }
}

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  late Future<List<AddReqPost>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = ApiService().fetchRequests(); // Fetch data on startup
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AddReqPost>>(
      future: _requests,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No requests found.'));
        } else {
          List<AddReqPost> requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(request.name),
                  subtitle: Text(
                    'Urgency: ${request.urgency}\nLocation: ${request.location}',
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Navigate to detail page if needed
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
