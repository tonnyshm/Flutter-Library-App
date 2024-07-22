import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'book_model.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  String _sortBy = 'Title';
  bool _isDarkMode = false;

  BookProvider() {
    _loadPreferences();
    _fetchBooks();
  }

  List<Book> get books {
    switch (_sortBy) {
      case 'Author':
        return _books..sort((a, b) => a.author.compareTo(b.author));
      case 'Rating':
        return _books..sort((a, b) => b.rating.compareTo(a.rating));
      default:
        return _books..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  String get sortBy => _sortBy;

  bool get isDarkMode => _isDarkMode;

  void addBook(Book book) async {
    final id = await DatabaseHelper.instance.insertBook(book);
    final newBook = book.copyWith(id: book.id);
    _books.add(newBook);
    notifyListeners();
  }

  void updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book);
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      notifyListeners();
    }
  }

  void deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  void searchBooks(String query) {
    if (query.isEmpty) {
      _fetchBooks();
    } else {
      _books = _books
          .where((book) =>
      book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }

  void setSortBy(String value) async {
    _sortBy = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sortBy', value);
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _sortBy = prefs.getString('sortBy') ?? 'Title';
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void _fetchBooks() async {
    _books = await DatabaseHelper.instance.getBooks();
    notifyListeners();
  }
}
