import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutCode4FunPage extends StatefulWidget {
  final String language;
  final bool isDarkMode;

  AboutCode4FunPage({required this.language, required this.isDarkMode, required Map data});

  @override
  _AboutCode4FunPageState createState() => _AboutCode4FunPageState();
}

class _AboutCode4FunPageState extends State<AboutCode4FunPage> {
  Map<String, String> _data = {'title': '', 'content': ''};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final ref = FirebaseDatabase.instance.ref("cardsData/aboutCode4Fun");
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _data = {
            'title': data['title_${widget.language}'] ?? 'No Title',
            'content': data['content_${widget.language}'] ?? 'No Content',
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "No data found in Firebase.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          _data['title']?.isNotEmpty == true
              ? _data['title']!
              : "About CODE4FUN",
          style: TextStyle(fontSize: 20),
          textDirection: widget.language == "fa" ? TextDirection.rtl : TextDirection.ltr,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _data['content'] ?? "No content available.",
            style: TextStyle(fontSize: 16),
            textDirection: widget.language == "fa"
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
