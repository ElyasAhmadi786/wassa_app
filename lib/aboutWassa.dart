import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutWassaPage extends StatefulWidget {
  final String language;
  final bool isDarkMode;

  AboutWassaPage({required this.language, required this.isDarkMode, required Map data});

  @override
  _AboutWassaPageState createState() => _AboutWassaPageState();
}

class _AboutWassaPageState extends State<AboutWassaPage> {
  Map<String, String> _data = {'title': '', 'content': ''};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final ref = FirebaseDatabase.instance.ref("cardsData/aboutWassa");
    try {
      final snapshot = await ref.get().timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Request timed out");
      });

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
        backgroundColor: Colors.amberAccent,
        title: Text(
          _data['title']?.isNotEmpty == true ? _data['title']! : "About WASSA",
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
