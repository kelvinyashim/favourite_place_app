import 'package:favourite_place/model/placeModel.dart';
import 'package:riverpod/riverpod.dart';

class UserPlaceNotifier extends StateNotifier {
  UserPlaceNotifier() : super(const []);

  void addplace(String title) {
    final newPlace = Places(title: title);
    state = [newPlace, ...state];
  }
}

final userPlaceProvider = StateNotifierProvider((ref) => UserPlaceNotifier());
