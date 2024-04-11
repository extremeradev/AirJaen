import 'dart:convert';

import 'package:http/http.dart' as http;


  Future<void> enviarEmail(String? name,  String? email,  String? subject,  String? message) async {
    final serviceId = 'service_zog34l8';
    final templateId = 'template_6wn1iaq';
    final userId = 'T7Qp2RrL77RAwMZOM';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url, 
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': name,
          'to_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      })
    );

    print(response.body);
  }
