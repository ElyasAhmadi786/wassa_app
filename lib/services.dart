// backgroundColor: Colors.orange,
// leading: IconButton(
// icon: Icon(Icons.arrow_back),
// onPressed: () => Navigator.pop(context),
// ),
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  ServicesPage({
    required this.language,
    required this.isDarkMode,
    required Map data,
  });

  @override
  Widget build(BuildContext context) {
    // داده‌های محلی برای عنوان و توضیحات کارت‌ها
    final localData = {
      "web": {
        "title": language == 'en' ? "Web Development" : "توسعه وب",
        "subtitle": language == 'en'
            ? "Learn HTML, CSS, and JavaScript."
            : "آموزش HTML، CSS و جاوا اسکریپت."
      },
      "mobile": {
        "title": language == 'en' ? "Mobile Development" : "توسعه موبایل",
        "subtitle": language == 'en'
            ? "Learn Flutter and Dart."
            : "آموزش Flutter و Dart."
      }
    };

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            language == 'en' ? "Services" : "خدمات", // عنوان صفحه
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان اصلی صفحه
              Text(
                language == 'en' ? "Our Services" : "خدمات ما",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
                textDirection:
                    language == "fa" ? TextDirection.rtl : TextDirection.ltr,
              ),
              SizedBox(height: 20),
              Expanded(
                // لیستی از کارت‌های خدمات
                child: ListView(
                  children: [
                    _buildServiceCard(
                      context,
                      title: localData['web']!['title']!, // عنوان محلی کارت وب
                      description: localData['web']![
                          'subtitle']!, // توضیحات محلی کارت وب
                      page: WebPage(
                        language: language,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildServiceCard(
                      context,
                      title: localData['mobile']![
                          'title']!, // عنوان محلی کارت موبایل
                      description: localData['mobile']![
                          'subtitle']!, // توضیحات محلی کارت موبایل
                      page: MobilePage(
                        language: language,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ویجت کارت‌های خدمات
  Widget _buildServiceCard(
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
              colors: [Colors.orange, Colors.deepOrangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, // نمایش عنوان کارت
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                description, // نمایش توضیحات کارت
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

class WebPage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  WebPage({required this.language, required this.isDarkMode});

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت داده‌ها از Firebase
  }

  /// تابع برای دریافت محتوای خدمات از Firebase
  Future<void> _fetchContent() async {
    final ref = FirebaseDatabase.instance.ref("cardsData/services/cards/web");
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
          _isLoading = false; // پایان بارگذاری
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
    return MaterialApp(
      theme:
          widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // تم پویا
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.language == 'en'
                ? "Web Development"
                : "توسعه وب", // عنوان صفحه
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

class MobilePage extends StatefulWidget {
  final String language; // زبان انتخاب‌شده
  final bool isDarkMode; // حالت شب/روز

  MobilePage({required this.language, required this.isDarkMode});

  @override
  _MobilePageState createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  String _content = ""; // محتوای دریافت‌شده از Firebase
  bool _isLoading = true; // وضعیت بارگذاری
  String? _errorMessage; // پیام خطا

  @override
  void initState() {
    super.initState();
    _fetchContent(); // دریافت داده‌ها از Firebase
  }

  /// تابع برای دریافت محتوای خدمات از Firebase
  Future<void> _fetchContent() async {
    final ref =
        FirebaseDatabase.instance.ref("cardsData/services/cards/mobile");
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
          _isLoading = false; // پایان بارگذاری
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
                ? "Mobile Development"
                : "توسعه موبایل", // عنوان صفحه
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
