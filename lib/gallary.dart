import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGalleryCard(context, "Pictures of Students", StudentsGalleryPage()),
            SizedBox(height: 20),
            _buildGalleryCard(context, "Pictures of Projects", ProjectsGalleryPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// صفحات مرتبط با گالری
class StudentsGalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pictures of Students"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Text(
          "Gallery of student pictures.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ProjectsGalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pictures of Projects"),
        backgroundColor: Colors.cyanAccent,
      ),
      body: Center(
        child: Text(
          "Gallery of project pictures.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
