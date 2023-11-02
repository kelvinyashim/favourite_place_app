import 'dart:convert';

import 'package:favourite_place/model/placeModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    var enteredTitle = "";
    bool isSending = false;

    void savePlace() async {
      if (_key.currentState!.validate()) {
        _key.currentState!.save();
        setState(() {
          isSending = true;
        });

        final url = Uri.https(
            'flutter-fave-default-rtdb.firebaseio.com', 'favourite.json');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'title': enteredTitle}),
        );

        if (!context.mounted) {
          return;
        }
        final resData = json.decode(response.body);
        
        Navigator.of(context).pop(Places(
          id: resData['name'],
          title: enteredTitle,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a place"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(children: [
            TextFormField(
              style: TextStyle(
                fontSize: 25,
              ),
              decoration: const InputDecoration(labelText: "Title"),
              maxLength: 20,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 20) {
                  return 'Must be between 1 and 20 characters.';
                }
                return null;
              },
              onSaved: (newValue) {
                enteredTitle = newValue!;
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: isSending ? null : () => savePlace(),
              label: isSending
                  ? SizedBox(
                      width: 6, height: 69, child: CircularProgressIndicator())
                  : const Text("Add place"),
            )
          ]),
        ),
      ),
    );
  }
}
