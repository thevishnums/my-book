import 'package:flutter/material.dart';

void main() {
  runApp(MyBooksApp());
}

class MyBooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Books',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginScreen(),
    );
  }
}

//////////////////////////////////////////////////////////
// 🔐 LOGIN SCREEN
//////////////////////////////////////////////////////////

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter username & password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("My Books",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => login(context),
                    child: Text("Login"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// 📚 BOOK LIST SCREEN
//////////////////////////////////////////////////////////

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Map<String, String>> books = [];

  void addBook(String title, String author) {
    if (title.isEmpty || author.isEmpty) return;

    setState(() {
      books.add({"title": title, "author": author});
    });
  }

  void editBook(int index, String title, String author) {
    setState(() {
      books[index] = {"title": title, "author": author};
    });
  }

  void showBookDialog({int? index}) {
    String title = index != null ? books[index]['title']! : '';
    String author = index != null ? books[index]['author']! : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? "Add Book" : "Edit Book"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: title),
              onChanged: (value) => title = value,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: TextEditingController(text: author),
              onChanged: (value) => author = value,
              decoration: InputDecoration(labelText: "Author"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (index == null) {
                addBook(title, author);
              } else {
                editBook(index, title, author);
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Books"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: books.isEmpty
            ? Center(
                child: Text(
                  "No books added 📚",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.book, color: Colors.deepPurple),
                      title: Text(books[index]['title']!),
                      subtitle: Text(books[index]['author']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showBookDialog(index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                books.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBookDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}