import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'login_screen.dart';
import 'book_detail_screen.dart';
import 'add_edit_book_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> allBooks = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;
  String searchQuery = '';
  int _selectedIndex = 0; // 0 for All, 1 for Favorites

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('books');

    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      allBooks = jsonList.map((e) => Book.fromJson(e)).toList();
    } else {
      allBooks = [];
    }

    _applyFilters();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = allBooks.map((b) => b.toJson()).toList();
    await prefs.setString('books', jsonEncode(jsonList));
  }

  void _applyFilters() {
    setState(() {
      filteredBooks = allBooks.where((book) {
        bool matchesSearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesTab = _selectedIndex == 0 || (_selectedIndex == 1 && book.isFavorite);
        return matchesSearch && matchesTab;
      }).toList();
    });
  }

  void _deleteBook(String id) {
    setState(() {
      allBooks.removeWhere((b) => b.id == id);
      _applyFilters();
    });
    saveBooks();
  }

  void _toggleFavorite(Book book) {
    setState(() {
      book.isFavorite = !book.isFavorite;
      _applyFilters();
    });
    saveBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredBooks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: _buildCoverImage(book.coverUrl),
                        title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(book.author),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                book.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: book.isFavorite ? Colors.red : null,
                              ),
                              onPressed: () => _toggleFavorite(book),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => _confirmDelete(book.id),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(
                                book: book,
                                onSave: (updatedBook) {
                                  int idx = allBooks.indexWhere((b) => b.id == updatedBook.id);
                                  if (idx != -1) allBooks[idx] = updatedBook;
                                  saveBooks();
                                },
                              ),
                            ),
                          );
                          loadBooks(); // reload after returning
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditBookScreen(
                onSave: (newBook) {
                  allBooks.add(newBook);
                  saveBooks();
                },
              ),
            ),
          );
          loadBooks();
        },
        child: Icon(Icons.add),
        tooltip: 'Add Book',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _applyFilters();
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'All Books'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search by title or author...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        icon: Icon(Icons.search, color: Colors.white),
      ),
      style: TextStyle(color: Colors.white, fontSize: 18),
      onChanged: (value) {
        searchQuery = value;
        _applyFilters();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            _selectedIndex == 1 ? "No favorites yet ❤️" : "No books found 📚",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url.isNotEmpty
          ? Image.network(
              url,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholderImage(),
            )
          : _placeholderImage(),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60,
      height: 80,
      color: Colors.grey.shade300,
      child: Icon(Icons.book, color: Colors.grey.shade500),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Book'),
        content: Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteBook(id);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
