import 'dart:convert';

import 'package:favourite_place/Screen/add.dart';
import 'package:favourite_place/model/placeModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Place extends StatefulWidget {
  Place({super.key});

  @override
  State<Place> createState() => _PlacesState();
}

class _PlacesState extends State<Place> {
  List<Places> favouritePlaces = [];
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    isLoading;
  }

  void load() async {
    try {
      final List<Places> fave = [];
      final url = Uri.https(
          'flutter-fave-default-rtdb.firebaseio.com', 'favourite.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result != null) {
          for (final item in result.entries) {
            fave.add(Places( title: item.value['title']));
          }
          // result.forEach((key, value) {
          //   fave.add(Places(title: value['title']));
          // });
        }
        setState(() {
          favouritePlaces = fave;
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load data: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        error = "An error occurred: $e";
      });
    }
  }

  void addButton() async {
    final result = await Navigator.of(context).push<Places>(MaterialPageRoute(
      builder: (context) => const Add(),
    ));

    if (result == null) {
      return;
    }

    setState(() {
      favouritePlaces.add(result);
    });
  }

  void remove(Places places){
    setState(() {
      favouritePlaces.remove(places);
    });
       final url = Uri.https(
          'flutter-fave-default-rtdb.firebaseio.com', 'favourite/${places.id}.json');
       http.delete(url);
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: 
      Text('Place removed', style: TextStyle(fontSize: 20),),
      elevation: 3.0,
      ),
      );


  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    Widget content = const Center(
        child: Text(
      "No items added yet",
      style: TextStyle(fontSize: 30),
    ));

    if (favouritePlaces.isNotEmpty) {
      content = InkWell(
        autofocus: true,
        splashColor: Theme.of(context).colorScheme.primary,
        onTap: () {},
        child: ListView.builder(
          itemCount: favouritePlaces.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(favouritePlaces[index]),
              onDismissed: (direction) => remove(favouritePlaces[index]),
              child: ListTile(
                title: Text(
                  favouritePlaces[index].title.toUpperCase(),
                  style: TextStyle(fontSize: 19),
                ),
              ),
            );
          },
        ),
      );

      if (error != null) {
        content = Center(
          child: Text(error!),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Places"),
          actions: [IconButton(onPressed: addButton, icon: Icon(Icons.add))],
        ),
        body: content);
  }
}
