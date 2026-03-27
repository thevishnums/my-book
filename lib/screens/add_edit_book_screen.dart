import 'package:flutter/material.dart';
import '../models/book.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;
  final Function(Book) onSave;

  const AddEditBookScreen({Key? key, this.book, required this.onSave}) : super(key: key);

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late String description;
  late String coverUrl;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    title = widget.book?.title ?? '';
    author = widget.book?.author ?? '';
    description = widget.book?.description ?? '';
    coverUrl = widget.book?.coverUrl ?? '';
    isFavorite = widget.book?.isFavorite ?? false;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newBook = Book(
        id: widget.book?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        author: author,
        description: description,
        coverUrl: coverUrl,
        isFavorite: isFavorite,
      );
      widget.onSave(newBook);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.book != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Book' : 'Add Book'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
                onSaved: (val) => title = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: author,
                decoration: InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter an author' : null,
                onSaved: (val) => author = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: coverUrl,
                decoration: InputDecoration(labelText: 'Cover Image URL (Optional)', border: OutlineInputBorder()),
                onSaved: (val) => coverUrl = val?.trim() ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
                maxLines: 4,
                onSaved: (val) => description = val?.trim() ?? '',
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('Save Book', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
