import 'package:flutter/material.dart';
import '../models/book.dart';
import 'add_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final Function(Book) onSave;

  const BookDetailScreen({Key? key, required this.book, required this.onSave}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Book currentBook;

  @override
  void initState() {
    super.initState();
    currentBook = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(currentBook.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: currentBook.isFavorite ? Colors.red : null,
            onPressed: () {
              setState(() {
                currentBook.isFavorite = !currentBook.isFavorite;
              });
              widget.onSave(currentBook);
            },
            tooltip: 'Toggle Favorite',
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditBookScreen(
                    book: currentBook,
                    onSave: (updatedBook) {
                      setState(() {
                        currentBook = updatedBook;
                      });
                      widget.onSave(currentBook);
                    },
                  ),
                ),
              );
            },
            tooltip: 'Edit',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentBook.coverUrl.isNotEmpty
                    ? Image.network(
                        currentBook.coverUrl,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                      )
                    : _placeholderImage(),
              ),
            ),
            SizedBox(height: 24),
            Text(
              currentBook.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "By ${currentBook.author}",
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24),
            Text(
              "Description",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              currentBook.description.isNotEmpty ? currentBook.description : "No description available.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 250,
      width: 180,
      color: Colors.grey.shade300,
      child: Icon(Icons.menu_book, size: 100, color: Colors.grey.shade500),
    );
  }
}
