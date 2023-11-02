import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Places {
  final id;
  final String title;
  Places({required this.title, required this.id});
}

