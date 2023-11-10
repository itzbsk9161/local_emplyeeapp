
/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://reqres.in/api/users";

  Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((employee) => employee as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
}
*/
