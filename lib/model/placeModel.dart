import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Places {
  final String id;
  final String title;
  Places({
    required this.title,
  }): id = uuid.v4();
}
