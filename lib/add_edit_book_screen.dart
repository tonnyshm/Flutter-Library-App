import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_model.dart';
import 'book_provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  AddEditBookScreen({this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _description;
  late double _rating;
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _title = widget.book!.title;
      _author = widget.book!.author;
      _description = widget.book!.description;
      _rating = widget.book!.rating;
      _isRead = widget.book!.isRead;
    } else {
      _title = '';
      _author = '';
      _description = '';
      _rating = 0;
      _isRead = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _rating.toString(),
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  return null;
                },
                onSaved: (value) {
                  _rating = double.parse(value!);
                },
              ),
              SwitchListTile(
                title: Text('Read'),
                value: _isRead,
                onChanged: (value) {
                  setState(() {
                    _isRead = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.book == null) {
                      final newBook = Book(
                        title: _title,
                        author: _author,
                        description: _description,
                        rating: _rating,
                        isRead: _isRead,
                      );
                      Provider.of<BookProvider>(context, listen: false).addBook(newBook);
                    } else {
                      final updatedBook = widget.book!.copyWith(
                        title: _title,
                        author: _author,
                        description: _description,
                        rating: _rating,
                        isRead: _isRead,
                      );
                      Provider.of<BookProvider>(context, listen: false).updateBook(updatedBook);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.book == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
