import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WhoBenefitsPage extends StatelessWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  WhoBenefitsPage(
      {required this.language, required this.isDarkMode, required Map data});

  @override
  Widget build(BuildContext context) {
    // داده‌های محلی کارت‌ها
    final localData = {
      "returnees": {
        "title": language == 'en' ? "Returnees" : "بازگشت‌کنندگان",
        "subtitle": language == 'en'
            ? "Learn about returnees."
            : "درباره بازگشت‌کنندگان بیشتر بدانید."
      },
      "idps": {
        "title": language == 'en' ? "IDPs" : "آوارگان داخلی",
        "subtitle": language == 'en'
            ? "Learn about Internally Displaced Persons."
            : "درباره آوارگان داخلی بیشتر بدانید."
      },
      "university": {
        "title": language == 'en' ? "University Students" : "دانشجویان",
        "subtitle": language == 'en'
            ? "Learn about university students."
            : "درباره دانشجویان بیشتر بدانید."
      },
      "school": {
        "title": language == 'en' ? "School Students" : "دانش‌آموزان",
        "subtitle": language == 'en'
            ? "Learn about school students."
            : "درباره دانش‌آموزان بیشتر بدانید."
      },
    };

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(), // تنظیم تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            language == 'en' ? "Who Benefits" : "چه کسانی بهره‌مند می‌شوند؟",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildBenefitCard(
                context,
                title: localData['returnees']!['title']!,
                description: localData['returnees']!['subtitle']!,
                page: ReturneesPage(language: language, isDarkMode: isDarkMode),
              ),
              SizedBox(height: 20),
              _buildBenefitCard(
                context,
                title: localData['idps']!['title']!,
                description: localData['idps']!['subtitle']!,
                page: IDPsPage(language: language, isDarkMode: isDarkMode),
              ),
              SizedBox(height: 20),
              _buildBenefitCard(
                context,
                title: localData['university']!['title']!,
                description: localData['university']!['subtitle']!,
                page: UniversityStudentsPage(
                    language: language, isDarkMode: isDarkMode),
              ),
              SizedBox(height: 20),
              _buildBenefitCard(
                context,
                title: localData['school']!['title']!,
                description: localData['school']!['subtitle']!,
                page: SchoolStudentsPage(
                    language: language, isDarkMode: isDarkMode),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ویجت کارت‌های لیست
  Widget _buildBenefitCard(
    BuildContext context, {
    required String title,
    required String description,
    required Widget page,
  }) {
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
              colors: [Colors.greenAccent, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, // عنوان کارت
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                description, // توضیحات کارت
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReturneesPage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  ReturneesPage({required this.language, required this.isDarkMode});

  @override
  _ReturneesPageState createState() => _ReturneesPageState();
}

class _ReturneesPageState extends State<ReturneesPage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت محتوا از Firebase
  }

  /// دریافت محتوا از Firebase
  Future<void> _fetchContent() async {
    final ref =
        FirebaseDatabase.instance.ref("cardsData/whoBenefits/returnees");
    try {
      final snapshot =
          await ref.get().timeout(Duration(seconds: 15), onTimeout: () {
        throw Exception("Timeout: Failed to fetch data from Firebase");
      });

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _content = data['content_${widget.language}'] ??
              (widget.language == 'en'
                  ? "No Content Available"
                  : "محتوایی یافت نشد");
          _isLoading = false; // بارگذاری تمام شد
        });
      } else {
        setState(() {
          _errorMessage =
              "No data found in Firebase."; // پیام خطا در صورت نبود داده
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e"; // خطا در دریافت داده‌ها
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.language == 'en'
                ? "Returnees"
                : "بازگشت‌کنندگان", // عنوان صفحه
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // نمایش Loading
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!, // نمایش پیام خطا
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _content, // نمایش محتوای دریافت‌شده
                      style: TextStyle(fontSize: 18),
                      textDirection: widget.language == "fa"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
      ),
    );
  }
}

class IDPsPage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  IDPsPage({required this.language, required this.isDarkMode});

  @override
  _IDPsPageState createState() => _IDPsPageState();
}

class _IDPsPageState extends State<IDPsPage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت محتوا از Firebase
  }

  /// دریافت محتوا از Firebase
  Future<void> _fetchContent() async {
    final ref = FirebaseDatabase.instance.ref("cardsData/whoBenefits/idps");
    try {
      final snapshot =
          await ref.get().timeout(Duration(seconds: 20), onTimeout: () {
        throw Exception("Timeout: Failed to fetch data from Firebase");
      });

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _content = data['content_${widget.language}'] ??
              (widget.language == 'en'
                  ? "No Content Available"
                  : "محتوایی یافت نشد");
          _isLoading = false; // بارگذاری تمام شد
        });
      } else {
        setState(() {
          _errorMessage =
              "No data found in Firebase."; // پیام خطا در صورت نبود داده
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e"; // خطا در دریافت داده‌ها
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.language == 'en' ? "IDPs" : "آورگان داخلی", // عنوان صفحه
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // نمایش Loading
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!, // نمایش پیام خطا
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _content, // نمایش محتوای دریافت‌شده
                      style: TextStyle(fontSize: 18),
                      textDirection: widget.language == "fa"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
      ),
    );
  }
}

class UniversityStudentsPage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  UniversityStudentsPage({required this.language, required this.isDarkMode});

  @override
  _UniversityStudentsPage createState() => _UniversityStudentsPage();
}

class _UniversityStudentsPage extends State<UniversityStudentsPage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت محتوا از Firebase
  }

  /// دریافت محتوا از Firebase
  Future<void> _fetchContent() async {
    final ref = FirebaseDatabase.instance
        .ref("cardsData/whoBenefits/universityStudents");
    try {
      final snapshot =
          await ref.get().timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Timeout: Failed to fetch data from Firebase");
      });

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _content = data['content_${widget.language}'] ??
              (widget.language == 'en'
                  ? "No Content Available"
                  : "محتوایی یافت نشد");
          _isLoading = false; // بارگذاری تمام شد
        });
      } else {
        setState(() {
          _errorMessage =
              "No data found in Firebase."; // پیام خطا در صورت نبود داده
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e"; // خطا در دریافت داده‌ها
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.language == 'en'
                ? "University Students"
                : "شاگردان پوهنتون", // عنوان صفحه
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // نمایش Loading
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!, // نمایش پیام خطا
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _content, // نمایش محتوای دریافت‌شده
                      style: TextStyle(fontSize: 18),
                      textDirection: widget.language == "fa"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
      ),
    );
  }
}

class SchoolStudentsPage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  SchoolStudentsPage({required this.language, required this.isDarkMode});

  @override
  _SchoolStudentsPage createState() => _SchoolStudentsPage();
}

class _SchoolStudentsPage extends State<SchoolStudentsPage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت محتوا از Firebase
  }

  /// دریافت محتوا از Firebase
  Future<void> _fetchContent() async {
    final ref =
        FirebaseDatabase.instance.ref("cardsData/whoBenefits/schoolStudents");
    try {
      final snapshot =
          await ref.get().timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Timeout: Failed to fetch data from Firebase");
      });

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _content = data['content_${widget.language}'] ??
              (widget.language == 'en'
                  ? "No Content Available"
                  : "محتوایی یافت نشد");
          _isLoading = false; // بارگذاری تمام شد
        });
      } else {
        setState(() {
          _errorMessage =
              "No data found in Firebase."; // پیام خطا در صورت نبود داده
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching data: $e"; // خطا در دریافت داده‌ها
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.language == 'en'
                ? "School Students"
                : "شاگردان مکاتب", // عنوان صفحه
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator()) // نمایش Loading
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!, // نمایش پیام خطا
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _content, // نمایش محتوای دریافت‌شده
                      style: TextStyle(fontSize: 18),
                      textDirection: widget.language == "fa"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
      ),
    );
  }
}
