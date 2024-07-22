import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_provider.dart';

class PreferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Sort By'),
            DropdownButton<String>(
              value: bookProvider.sortBy,
              items: <String>['Title', 'Author', 'Rating']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (value) {
                bookProvider.setSortBy(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
