import 'package:flutter_dotenv/flutter_dotenv.dart';

String backendApiUrl = "${dotenv.env['BACKEND_URL']}";
